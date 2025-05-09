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
--layout-features=\"\" \
"

echo "========== BUILD SUITE =========="

# Build
rm -rf ./output-suite
mkdir -p output-suite

cp ../suite/fonts/variable/woff2/SUITE-Variable.woff2 output-suite/SUITE.woff2
hash_filename "./output-suite/"

python3 ./process-suite.py

echo "========== COMPLETE SUITE =========="
