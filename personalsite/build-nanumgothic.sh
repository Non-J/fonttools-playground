#!/bin/sh

fontsubset="\
--layout-features=* \
--unicodes=\"U+000D,U+0020,U+00A0,U+AC00,U+AD6D,U+ADF8,U+AE30,U+B294,U+B2C8,U+B2E4,U+B77C,U+B825,U+B85C,U+B978,U+B97C,U+BE14,U+C1A1,U+C218,U+C2A4,U+C2B5,U+C5B4,U+C5C6,U+C5D0,U+C601,U+C6D0,U+C704,U+C744,U+C774,U+C785,U+C788,U+C815,U+C8C4,U+C9C0,U+CC3E,U+D2B8,U+D310,U+D398,U+D3EC,U+D558,U+D55C,U+D569,U+D648\" \
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
