# PiP Awake

iPhone の画面を点けたままにするための iOS アプリです。PiP（ピクチャ・イン・ピクチャ）で、経過時間と給電状況を映した映像を再生し続けます。

公開サイト: https://akidon0000.github.io/pip-awake/

## 使い方

- 「表示」タブの「開始」で PiP を開始し、「停止」で止めます。
- 「設定」タブで次の値を変えられます。値は保存され、次に起動したときも同じ値になります。
  - 給電状況（「給電中」「未給電」）の表示のオン・オフ
  - 映像の高さと横幅（ピクセル）。横幅と高さの比率が PiP 窓の形になります。
- 設定の変更は、次に「開始」したときから反映されます。

## 状態

- 給電状態の検知は未実装です。「給電中」は常に表示されます。
- 実機での長時間の動作と、画面を点けたままにする効果は未確認です。
- ipa のインストール手順は未確認です。下の手順は Sideloadly と AltStore の一般的な使い方に基づきます。

## インストール（ipa）

配布する ipa は未署名です。インストールする人が自分の Apple ID で署名します。

1. 公開サイトから `PipAwake.ipa` を取得する。
2. Sideloadly か AltStore で iPhone に入れる。このとき自分の Apple ID で署名される。
3. iPhone で 設定 > 一般 > VPN とデバイス管理 を開き、開発元を信頼する。
4. 無料の Apple ID で署名した場合、約 7 日で期限が切れる。期限が切れたら入れ直す。

## ソースからビルドする

必要なもの: Xcode と [XcodeGen](https://github.com/yonaskolb/XcodeGen)

```bash
brew install xcodegen
xcodegen generate
open PipAwake.xcodeproj
```

- `project.yml` の `DEVELOPMENT_TEAM` を自分の Team ID に変えてから実機で動かす。
- 未署名の ipa を作るには `scripts/build-unsigned-ipa.sh <出力ディレクトリ>` を実行する。
- テストは iOS Simulator で実行する。

```bash
xcodebuild test -project PipAwake.xcodeproj -scheme PipAwake \
  -destination 'platform=iOS Simulator,name=<シミュレータ名>'
```

## リポジトリ構成（モノレポ）

| パス | 内容 |
|---|---|
| `PipAwake/` | iOS アプリのソース |
| `PipAwakeTests/` | 単体テスト |
| `Web/` | 公開サイト（[Swift Ignite](https://github.com/twostraws/Ignite)） |
| `scripts/` | 未署名 ipa のビルドスクリプト |
| `docs/` | 設計 spec と実装計画 |
| `project.yml` | XcodeGen の定義。`PipAwake.xcodeproj` はここから生成する |

## 公開サイト（Web/）

`main` に push すると `.github/workflows/pages.yml` が動きます。未署名の ipa を作り、サイトと一緒に GitHub Pages へ公開します。

ローカルでサイトを作る場合:

```bash
cd Web
xcrun swift run PipAwakeWeb   # 生成物は Web/Build
```

- Swift 6.0 以上と macOS 14 以上が必要です。
- Xcode に付属の Swift（`xcrun swift`）を使ってください。別にインストールした Swift 6.2 では依存パッケージのビルドがクラッシュしました。
- Pages の公開には、リポジトリの Settings > Pages で Source を GitHub Actions にします。
