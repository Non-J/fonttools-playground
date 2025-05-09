#!/bin/sh

# ====== Utils ======

urlsafe_base64() {
    base64 | tr '+/' '-_' | tr -d '='
}

hash_filename() {
    local target_dir="$1"

    find "$target_dir" -type f | while read -r filepath; do
        dir=$(dirname "$filepath")
        filename=$(basename "$filepath")
        base="${filename%.*}"
        ext="${filename##*.}"

        # Handle files with no extension
        if [ "$base" = "$filename" ]; then
            ext=""
        fi

        # Compute SHA-1 hash and get first 8 characters of URL-safe base64
        hash=$(sha1sum "$filepath" | awk '{print $1}' | xxd -r -p | urlsafe_base64 | cut -c1-8)

        # Construct new filename
        if [ -n "$ext" ]; then
            newname="${base}.${hash}.${ext}"
        else
            newname="${base}.${hash}"
        fi

        newpath="${dir}/${newname}"

        # Rename if names differ
        if [ "$filepath" != "$newpath" ]; then
            mv "$filepath" "$newpath"
            echo "Output: $filepath -> $newpath"
        fi
    done
}

# =================

fontsubset="\
--layout-features=\"kern,liga,clig,calt,ccmp,locl,mark,mkmk,rvrn,case,frac,numr,dnom,sinf,subs,sups\" \
--unicodes=\"U+0000-00A0,U+00A4,U+00A6-00A9,U+00AB-00AE,U+00B0-00B7,U+00B9-00BE,U+00D7,U+00F7,U+03BC,U+03C0,U+2000-206F,U+2070-208F,U+2113,U+2116,U+2122,U+212E,U+215B-215B,U+2190-21BB,U+2212,U+2215,U+221E,U+2248,U+2260,U+2264,U+2265,U+F8FF,U+FEFF,U+FFFD\" \
"

echo "========== BUILD LEXEND =========="

rm -rf ./output-lexend

# Build
mkdir -p output-lexend
gftools builder lexend.yaml

# Instanciate HEXP variable
fonttools varLib.instancer ./output-lexend/variable/Lexend[HEXP,wght].ttf HEXP=0 --output ./output-lexend/variable/Lexend[wght].ttf

# Subset to basic English only
eval "pyftsubset ./output-lexend/variable/Lexend[wght].ttf --output-file=\"output-lexend/lexend.ttf\" $fontsubset"
eval "pyftsubset ./output-lexend/variable/Lexend[wght].ttf --flavor=woff2 --output-file=\"output-lexend/lexend.woff2\" $fontsubset"

# Export for legacy browser compatibility
mkdir -p output-lexend/legacy-compat
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=100 --output ./output-lexend/legacy-compat/lexend-100.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=200 --output ./output-lexend/legacy-compat/lexend-200.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=300 --output ./output-lexend/legacy-compat/lexend-300.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=400 --output ./output-lexend/legacy-compat/lexend-400.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=500 --output ./output-lexend/legacy-compat/lexend-500.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=600 --output ./output-lexend/legacy-compat/lexend-600.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=700 --output ./output-lexend/legacy-compat/lexend-700.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=800 --output ./output-lexend/legacy-compat/lexend-800.ttf
fonttools varLib.instancer ./output-lexend/lexend.ttf wght=900 --output ./output-lexend/legacy-compat/lexend-900.ttf

hash_filename "./output-lexend/"

echo "========== COMPLETE LEXEND =========="
