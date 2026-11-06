#!/bin/bash
set -euo pipefail
root="$(cd "$(dirname "$0")" && pwd)"
if [[ "$(uname -s)" != Darwin ]]; then
  echo "Build requires a supported Mac with Xcode 27 or later. No build was attempted." >&2
  exit 2
fi
version="$(xcodebuild -version | awk 'NR==1 {print $2}')"
major="${version%%.*}"
if [[ ! "$major" =~ ^[0-9]+$ ]] || (( major < 27 )); then
  echo "Xcode 27 / Swift 6.4 / iOS 27 SDK is required. No build was attempted." >&2
  exit 2
fi
mkdir -p "$root/build" "$root/dist"
xcodebuild -version > "$root/dist/toolchain.txt"
xcrun --sdk iphoneos --show-sdk-version >> "$root/dist/toolchain.txt"
xcodebuild -project "$root/SiriProviderProbe.xcodeproj" \
  -scheme SiriProviderProbe -configuration Release \
  -sdk iphoneos -destination 'generic/platform=iOS' \
  -derivedDataPath "$root/build/DerivedData" \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  build > "$root/dist/build.log" 2>&1
app="$root/build/DerivedData/Build/Products/Release-iphoneos/SiriProviderProbe.app"
test -f "$app/SiriProviderProbe"
stage="$(mktemp -d "$root/build/package.XXXXXX")"
mkdir "$stage/Payload"
/usr/bin/ditto "$app" "$stage/Payload/SiriProviderProbe.app"
(cd "$stage" && /usr/bin/ditto -c -k --keepParent Payload "$root/dist/SiriProviderProbe-unsigned.ipa")
/usr/bin/shasum -a 256 "$root/dist/SiriProviderProbe-unsigned.ipa" > "$root/dist/ipa.sha256"
echo "Unsigned artifact built. Signing, installation and native Siri acceptance remain unverified."
