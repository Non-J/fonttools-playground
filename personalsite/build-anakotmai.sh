#!/bin/sh

fontsubset="\
--layout-features=\"ccmp,liga,pnum,kern,mark,mkmk\" \
--unicodes=\"U+000D,U+0020,U+00A0,U+0E00-0E7F\" \
"

echo "========== BUILD ANAKOTMAI =========="

# Build
mkdir -p output-anakotmai

eval "pyftsubset ../anakotmai/Anakotmai-Light.ttf --output-file=\"output-anakotmai/Anakotmai-Light.ttf\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Medium.ttf --output-file=\"output-anakotmai/Anakotmai-Medium.ttf\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Bold.ttf --output-file=\"output-anakotmai/Anakotmai-Bold.ttf\" $fontsubset"

eval "pyftsubset ../anakotmai/Anakotmai-Light.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Light.woff2\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Medium.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Medium.woff2\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Bold.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Bold.woff2\" $fontsubset"

echo "========== COMPLETE ANAKOTMAI =========="
