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
--layout-features=\"ccmp,liga,pnum,kern,mark,mkmk,aalt\" \
--unicodes=\"U+000D,U+0020,U+00A0,U+00AD,U+0E00-0E7F\" \
"

echo "========== BUILD ANAKOTMAI =========="

rm -rf ./output-anakotmai

# Build
mkdir -p output-anakotmai

eval "pyftsubset ../anakotmai/Anakotmai-Light.ttf --output-file=\"output-anakotmai/Anakotmai-Light.ttf\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Medium.ttf --output-file=\"output-anakotmai/Anakotmai-Medium.ttf\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Bold.ttf --output-file=\"output-anakotmai/Anakotmai-Bold.ttf\" $fontsubset"

eval "pyftsubset ../anakotmai/Anakotmai-Light.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Light.woff2\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Medium.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Medium.woff2\" $fontsubset"
eval "pyftsubset ../anakotmai/Anakotmai-Bold.ttf --flavor=woff2 --output-file=\"output-anakotmai/Anakotmai-Bold.woff2\" $fontsubset"

hash_filename "./output-anakotmai/"

echo "========== COMPLETE ANAKOTMAI =========="
