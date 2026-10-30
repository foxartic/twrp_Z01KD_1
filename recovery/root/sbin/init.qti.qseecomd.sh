#!/sbin/sh
# Mount/provision TA paths for qseecomd + cryptfs keymaster.
# MUST NOT query system properties: this script runs inside init's blocking
# exec, and init's property service cannot answer while blocked (deadlock).
# Just do the mounts and exit immediately.

# keymaster + listener TAs live in /system/vendor/firmware (non-treble Oreo)
if ! grep -q " /system " /proc/mounts; then
    mount -r -t ext4 /dev/block/bootdevice/by-name/system /system 2>/dev/null
fi

# firmware partition -> /firmware; else expose system's firmware dir
if ! grep -q " /firmware " /proc/mounts; then
    if [ -e /dev/block/bootdevice/by-name/firmware ]; then
        mkdir -p /firmware
        mount -t ext4 /dev/block/bootdevice/by-name/firmware /firmware 2>/dev/null
    elif [ -d /system/vendor/firmware ]; then
        mkdir -p /firmware
        for f in /system/vendor/firmware/*; do
            ln -s "$f" /firmware/ 2>/dev/null
        done
    fi
fi

# qseecomd/QSEEComAPI also probe /vendor/firmware (keep our /vendor/lib64 blobs)
if [ -d /system/vendor/firmware ] && [ ! -e /vendor/firmware ]; then
    mkdir -p /vendor/firmware
    for f in /system/vendor/firmware/*; do
        ln -s "$f" /vendor/firmware/ 2>/dev/null
    done
fi
exit 0
