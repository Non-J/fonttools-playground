#!/bin/sh

fontsubset="\
--layout-features=* \
--unicodes=\"U+000D,U+0020,U+00A0,U+AD6D,U+C5B4,U+D55C\" \
"

echo "========== BUILD Nanum Gothic =========="

# Build
mkdir -p output-nanumgothic

eval "pyftsubset ../nanumgothic/NanumGothic-Regular.ttf --output-file=\"output-nanumgothic/NanumGothic-Regular.ttf\" $fontsubset"
eval "pyftsubset ../nanumgothic/NanumGothic-Bold.ttf --output-file=\"output-nanumgothic/NanumGothic-Bold.ttf\" $fontsubset"
eval "pyftsubset ../nanumgothic/NanumGothic-ExtraBold.ttf --output-file=\"output-nanumgothic/NanumGothic-ExtraBold.ttf\" $fontsubset"

eval "pyftsubset ../nanumgothic/NanumGothic-Regular.ttf --flavor=woff2 --output-file=\"output-nanumgothic/NanumGothic-Regular.woff2\" $fontsubset"
eval "pyftsubset ../nanumgothic/NanumGothic-Bold.ttf --flavor=woff2 --output-file=\"output-nanumgothic/NanumGothic-Bold.woff2\" $fontsubset"
eval "pyftsubset ../nanumgothic/NanumGothic-ExtraBold.ttf --flavor=woff2 --output-file=\"output-nanumgothic/NanumGothic-ExtraBold.woff2\" $fontsubset"

echo "========== COMPLETE Nanum Gothic =========="
