# OpenWrt apt-cacher-ng feed

## News
* 2020-06-08 Update to openwrt 19.07.3 - apt-cacher-ng 3.5

## Build the package from apt-cacher-ng feed
1. Download SDK for your board. Note this is only an example. You have to select and download the SDK for your particular board.
    ```
    wget https://downloads.openwrt.org/releases/19.07.3/targets/mvebu/cortexa9/openwrt-sdk-19.07.3-mvebu-cortexa9_gcc-7.5.0_musl_eabi.Linux-x86_64.tar.xz
    ```

1. Extract SDK
    ```
    tar -xJf openwrt-sdk-19.07.3-mvebu-cortexa9_gcc-7.5.0_musl_eabi.Linux-x86_64.tar.xz
    ```

1. Use the provided feed
    * a. Enable local modifications
        - Download apt-cacher-ng feed from github
            ```
            git clone https://github.com/vasvir/openwrt-packages.git
            ```
        - Edit feeds.conf.default in the sdk downloaded and extracted before. Add
            ```
            src-link local /home/bill/Downloads/hardware/linksys1200ac/openwrt-packages
            ```

    * b. Or Use the feed directly from github
        - Adjust feeds.conf.default. Add
            ```
            src-git local https://github.com/vasvir/openwrt-packages.git
            ```

1. Configure local packages
    ```
    cd openwrt-sdk-19.07.3-mvebu-cortexa9_gcc-7.5.0_musl_eabi.Linux-x86_64
    ./scripts/feeds update -a
    ./scripts/feeds install apt-cacher-ng
    make menuconfig
    ```

    menuconfig should show apt-cacher-ng under Network/Web Servers/Proxies [1]

1. Install local signing keys
    ```
    ./staging_dir/host/bin/usign -G -s ./key-build -p ./key-build.pub -c "Local build key"
    ```

1. Build package [2]
    ```
    make -j5
    ```

1. Copy ipk file over to openwrt router
    ```
    scp bin/packages/arm_cortex-a9_vfpv3-d16/local/apt-cacher-ng_3.5-1_arm_cortex-a9_vfpv3-d16.ipk root@openwrt:
    ```

1. Install the apt-cacher-ng package [3]
    ```
    ssh root@openwrt
    opkg install apt-cacher-ng_3.5-1_arm_cortex-a9_vfpv3-d16.ipk
    ```
    
1. Configure apt-cacher-ng service
    * edit /etc/apt-cacher-ng/acng.conf to configure the cachedir and logdir
    * create cachedir, logdir and /var/run/apt-cacher-ng/. Chown them to apt-cacher-ng.apt-cacher.ng

1. Restart the service
    ```
    /etc/init.d/apt-cacher-ng restart
    ```

## TODO
* Adjust pathnames in README.md
* Use procd
* Autoconfigure step 9

## Troubleshooting
This is possible only if you have followed step 3a.

friendly commands
* make V=s
* make V=s package/feeds/local/apt-cacher-ng/compile
* make V=s package/feeds/local/apt-cacher-ng/install

### [1] Buildroot Makefile problem.
Adjust /home/bill/Downloads/hardware/linksys1200ac/openwrt-packages/apt-cacher-ng/Makefile and retry
```
./scripts/feeds uninstall apt-cacher-ng
rm -rf build_dir/target-arm_cortex-a9+vfpv3-d16_musl_eabi/apt-cacher-ng-3.5/
./scripts/feeds install apt-cacher-ng
make menuconfig
```

This may help if you need to update dependencies
```
./scripts/feeds update -a
```

### [2] Package CMakeLists.txt problem.
Adjust /home/bill/Downloads/hardware/linksys1200ac/openwrt-packages/apt-cacher-ng/patches/000-add_install_target.patch and retry:
* setup once:
    * download the apt-cacher-ng source
        ```
        wget http://ftp.us.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_3.5.orig.tar.xz
        ```

    * extract it
         ```
         tar -xJf apt-cacher-ng_3.5.orig.tar.xz
         ```

    * rename and copy it to have an easy diff target
         ```
         mv apt-cacher-ng_3.5 a
         cp -a a b
         ```

* edit test cycle
    * modify b - produce patches for CMakeLists.txt and move them over to /home/bill/Downloads/hardware/linksys1200ac/openwrt-packages/apt-cacher-ng/patches/000-add_install_target.patch
        ```
       diff -ur a b > /home/bill/Downloads/hardware/linksys1200ac/openwrt-packages/apt-cacher-ng/patches/000-add_install_target.patch
        ```

    * build
        ```
        rm -rf build_dir/target-arm_cortex-a9+vfpv3-d16_musl_eabi/apt-cacher-ng-3.5/ 
        make V=s
        ```

### [3] Installation problems in postinst.
Adjust Buildroot Makefile and retry:
```
ssh root@openwrt opkg remove apt-cacher-ng
./scripts/feeds uninstall apt-cacher-ng
rm -rf build_dir/target-arm_cortex-a9+vfpv3-d16_musl_eabi/apt-cacher-ng-3.5/
./scripts/feeds install apt-cacher-ng
make -j5
scp bin/packages/arm_cortex-a9_vfpv3-d16/local/apt-cacher-ng_3.5-1_arm_cortex-a9_vfpv3-d16.ipk root@openwrt:
ssh root@openwrt opkg install apt-cacher-ng_3.5-1_arm_cortex-a9_vfpv3-d16.ipk
```
