#!/bin/sh

fontsubset="\
--layout-features=* \
--unicodes=\"U+1F1E6-1F1FF,U+1F3F4,U+E0061-E007A,U+E007F\" \
"

echo "========== BUILD TWEMOJI FLAG =========="

mkdir -p output-twemoji
cd output-twemoji

wget -O TwemojiMozilla.ttf https://github.com/mozilla/twemoji-colr/releases/latest/download/TwemojiMozilla.ttf

eval "pyftsubset TwemojiMozilla.ttf --output-file=\"twemoji.ttf\" $fontsubset"
eval "pyftsubset TwemojiMozilla.ttf --flavor=woff2 --output-file=\"twemoji.woff2\" $fontsubset"

echo "========== COMPLETE TWEMOJI FLAG =========="
