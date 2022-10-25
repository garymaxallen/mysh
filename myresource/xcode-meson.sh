#!/bin/bash
#set -x
# Try to figure out the user's PATH to pick up their installed utilities.
export PATH="$PATH:$(sudo -u "$USER" -i printenv PATH)"

#mkdir -p "$MESON_BUILD_DIR"
mkdir -p build/Release-iphonesimulator/meson
cd build/Release-iphonesimulator/meson

config=$(meson introspect --buildoptions)
if [[ $? -ne 0 ]]; then
    export CC_FOR_BUILD="env -u SDKROOT -u IPHONEOS_DEPLOYMENT_TARGET xcrun clang"
    export CC="$CC_FOR_BUILD" # compatibility with meson < 0.54.0
    crossfile=cross.txt
    arch_args=''\''-arch'\'', '\''x86_64'\'', '\''-arch'\'', '\''arm64'\'''
    meson_arch=arm64
    case "$meson_arch" in
        arm64) meson_arch=aarch64 ;;
    esac
    cat | tee $crossfile <<-EOF
    [binaries]
    c = 'clang'
    ar = 'ar'

    [host_machine]
    system = 'darwin'
    cpu_family = '$meson_arch'
    cpu = '$meson_arch'
    endian = 'little'

    [built-in options]
    c_args = [$arch_args]
    
    [properties]
    needs_exe_wrapper = true
EOF
    #(set -x; meson $SRCROOT --cross-file $crossfile) || exit $?
    meson /Users/pcl/Documents/tmp/myish2 --cross-file cross.txt
    config=$(meson introspect --buildoptions)
fi

buildtype=debug
b_ndebug=false

buildtype=debugoptimized

b_sanitize=none
#log=$ISH_LOG
log_handler=nslog
kernel=ish

for var in buildtype log b_ndebug b_sanitize log_handler kernel; do
    old_value=$(python3 -c "import sys, json; v = next(x['value'] for x in json.load(sys.stdin) if x['name'] == '$var'); print(str(v).lower() if isinstance(v, bool) else v)" <<< $config)
    new_value=${!var}
    if [[ $old_value != $new_value ]]; then
        #set -x; meson configure "-D$var=$new_value"
        meson configure "-D$var=$new_value"
    fi
done
