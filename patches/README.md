# OrangeFox 12.1 build patches

These patches are required on top of the stock `fox_12.1` manifest so that
`vendor/recovery/OrangeFox_A12.sh` actually runs and applies the OrangeFox
theme/branding to the recovery ramdisk.

Apply before building:

```bash
cd build/make        && patch -p1 < ../../device/asus/Z01K/patches/build-make-orangefox.patch
cd vendor/twrp       && patch -p1 < ../../device/asus/Z01K/patches/vendor-twrp-orangefox.patch
cd system            && patch -p1 < ../device/asus/Z01K/patches/system-orangefox.patch
```

`system-orangefox.patch` also contains the `system/core` hunks; `system/`
itself is not a git repo, hence it is kept as the upstream diff.
