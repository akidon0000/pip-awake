#!/usr/bin/env bash
# 未署名の .ipa を作る。署名はインストールする人が自分の Apple ID で行う（Sideloadly / AltStore など）。
# このリポジトリには証明書もプロビジョニングプロファイルも含めない。
#
# 使い方: scripts/build-unsigned-ipa.sh <出力ディレクトリ>
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out_dir="${1:?出力ディレクトリを指定する}"
mkdir -p "$out_dir"
out_dir="$(cd "$out_dir" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

xcodebuild \
  -project "$root/PipAwake.xcodeproj" \
  -scheme PipAwake \
  -configuration Release \
  -sdk iphoneos \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$work/derived" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY="" \
  build

app="$work/derived/Build/Products/Release-iphoneos/PipAwake.app"
mkdir -p "$work/package/Payload"
cp -R "$app" "$work/package/Payload/"
rm -f "$out_dir/PipAwake.ipa"
(cd "$work/package" && zip -qry "$out_dir/PipAwake.ipa" Payload)
echo "作成: $out_dir/PipAwake.ipa"
