#!/bin/sh

function compare_sdks() {
    local old_version=$1
    local new_version=$2
    local sdk_id=$3

    local old_path="/Applications/Xcode-${old_version}.app/Contents/Developer/Platforms/${sdk_id}.platform/Developer/SDKs/${sdk_id}.sdk"
    local new_path="/Applications/Xcode-${new_version}.app/Contents/Developer/Platforms/${sdk_id}.platform/Developer/SDKs/${sdk_id}.sdk"
    local display_name=$(/usr/libexec/PlistBuddy -c "Print :DisplayName" "${new_path}/SDKSettings.plist" | sed 's/ /-/g')

    figlet "${display_name}"

    swift run -c release ocdiff \
        --skip-error \
        --old "${old_path}" \
        --new "${new_path}" \
        --html "html_report/${display_name}-xcode-${new_version}"
}

function compare_xcodes() {
    local old_version=$1
    local new_version=$2

    figlet "Xcode ${old_version} -> ${new_version}"

    compare_sdks ${old_version} ${new_version} iPhoneOS
    compare_sdks ${old_version} ${new_version} MacOSX
    compare_sdks ${old_version} ${new_version} AppleTVOS
    compare_sdks ${old_version} ${new_version} WatchOS
}

mkdir html_report

#compare_xcodes $1 $2

compare_xcodes "13.4.1" "14-beta-1"

#compare_xcodes "13.4"    "13.4.1"
#compare_xcodes "13.3.1"  "13.4"
#compare_xcodes "13.3"    "13.3.1"
#compare_xcodes "13.2.1"  "13.3"
#compare_xcodes "13.2"    "13.2.1"
#compare_xcodes "13.1"    "13.2"
#compare_xcodes "13"      "13.1"
#compare_xcodes "12.5.1"  "13"
