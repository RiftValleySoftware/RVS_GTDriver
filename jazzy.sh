#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
rm -drf docs/*

jazzy   --github_url https://github.com/RiftValleySoftware/RVS_GTDriver \
        --readme ./README-API.md \
        --theme fullwidth \
        --author The\ Great\ Rift\ Valley\ Software\ Company \
        --author_url https://riftvalleysoftware.com \
        --title RVS_BTDriver\ Public\ API\ Doumentation \
        --min_acl public \
        --module RVS_BTDriver_iOS
cp icon.png docs/icon.png
cp img/* docs/img

jazzy   --github_url https://github.com/RiftValleySoftware/RVS_GTDriver \
        --readme ./README.md \
        --theme fullwidth \
        --author The\ Great\ Rift\ Valley\ Software\ Company \
        --author_url https://riftvalleysoftware.com \
        --title RVS_BTDriver\ Public\ Internal\ Code\ Doumentation \
        --output docs/internal \
        --min_acl private
cp icon.png docs/internal/icon.png
cp img/* docs/internal/img

cd "${CWD}"
