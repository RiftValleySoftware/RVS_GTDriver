#!/bin/sh
CWD="$(pwd)"
MY_SCRIPT_PATH=`dirname "${BASH_SOURCE[0]}"`
cd "${MY_SCRIPT_PATH}"
rm -drf docs/*

echo "Creating API Docs for the Driver"

jazzy   --readme ./README-API.md \
        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver \
        --title RVS_BTDriver\ Public\ API\ Doumentation \
        --min_acl public \
        --build-tool-arguments -scheme,RVS_BTDriver_MacOS
cp icon.png docs/icon.png
cp img/* docs/img

echo "Creating Internal Docs for the Driver"

jazzy   --readme ./README.md \
        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver \
        --title RVS_BTDriver\ Public\ Internal\ Code\ Doumentation \
        --output docs/internal \
        --build-tool-arguments -scheme,RVS_BTDriver_MacOS \
        --min_acl private
cp icon.png docs/internal/icon.png
cp img/* docs/internal/img

echo "Creating MacOS Test Harness Docs"

jazzy   --readme ./README-MacOS-Harness.md \
        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_MacOS_Test_Harness \
        --title RVS_BTDriver\ MacOS\ Test\ Harness\ Project\ Code\ Doumentation \
        --output docs/macOSTestHarness \
        --build-tool-arguments -scheme,RVS_BTDriver_MacOS_Test_Harness \
        --min_acl private
cp img/TestHarnessIcon.png docs/macOSTestHarness/icon.png
cp img/* docs/macOSTestHarness/img

echo "Creating iOS Test Harness Docs"

jazzy   --readme ./README-iOS-Harness.md \
        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_iOS_Test_Harness \
        --title RVS_BTDriver\ iOS/iPadOS\ Test\ Harness\ Project\ Code\ Doumentation \
        --output docs/iOSTestHarness \
        --build-tool-arguments -scheme,RVS_BTDriver_iOS_Test_Harness \
        --min_acl private
cp img/TestHarnessIcon.png docs/iOSTestHarness/icon.png
cp img/* docs/iOSTestHarness/img

echo "Creating WatchOS Test Harness Docs"

jazzy   --readme ./README-WatchOS-Harness.md \
        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_WatchOS_Test_Harness \
        --title RVS_BTDriver\ WatchOS\ Test\ Harness\ Project\ Code\ Doumentation \
        --output docs/watchOSTestHarness \
        --build-tool-arguments -scheme,RVS_BTDriver_WatchOS_Test_Harness \
        --min_acl private
cp img/TestHarnessIcon.png docs/watchOSTestHarness/icon.png
cp img/* docs/watchOSTestHarness/img

#echo "Creating tvOS Test Harness Docs"
#
#jazzy   --readme ./README-API.md \
#        --github_url https://github.com/RiftValleySoftware/RVS_GTDriver/tree/master/RVS_BTDriver_tvOS_Test_Harness \
#        --title RVS_BTDriver\ tvOS\ Test\ Harness\ Project\ Code\ Doumentation \
#        --output docs/tvOSTestHarness \
#        --build-tool-arguments -scheme,RVS_BTDriver_tvOS_Test_Harness \
#        --min_acl private
#cp img/TestHarnessIcon.png docs/tvOSTestHarness/icon.png
#cp img/* docs/tvOSTestHarness/img

cd "${CWD}"
