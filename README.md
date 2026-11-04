# PiP Awake

iPhone の画面を点けたままにするための iOS アプリです。PiP（ピクチャ・イン・ピクチャ）で、経過時間と給電状況を映した映像を再生し続けます。

公開サイト: https://akidon0000.github.io/pip-awake/

## 使い方

- 「表示」タブの「開始」で PiP を開始し、「停止」で止めます。
- 「設定」タブで映像の高さと横幅を、スライダーで変えられます。横幅は 50px から画面の横幅まで選べます。値は保存され、次に起動したときも同じ値になります。横幅と高さの比率が PiP 窓の形になります。
- 設定の変更は、次に「開始」したときから反映されます。

## 状態

- 実機での長時間の動作と、画面を点けたままにする効果は未確認です。
- 下の手順で他の人が自分の iPhone に入れる作業は、まだ試していません。

## インストール

このアプリは ipa では配布していません。Xcode でソースからビルドして、自分の iPhone に直接入れます。

必要なもの

- Mac（Xcode がインストールされていること）
- iPhone（iOS 17 以上）
- Apple ID（無料のもので可）

手順

1. リポジトリを取得して、プロジェクトを開きます。

   ```bash
   git clone https://github.com/akidon0000/pip-awake.git
   cd pip-awake
   open PipAwake.xcodeproj
   ```

2. Xcode で Apple ID を追加します（Xcode > Settings > Accounts）。
3. 左のナビゲータで PipAwake プロジェクトを選び、PipAwake ターゲットの Signing & Capabilities を開きます。Team で自分のチームを選びます。「Bundle Identifier が使えない」と出たら、`dev.akidon.pipawake` 以外の自分専用の値に変えます。
4. iPhone を Mac につなぎ、実行先に iPhone を選んで ▶ を押します。
5. 初回だけ、iPhone の 設定 > プライバシーとセキュリティ > デベロッパモード をオンにします（iOS 16 以上）。
6. 初回だけ、iPhone の 設定 > 一般 > VPN とデバイス管理 で、自分の Apple ID の開発元を信頼します。
7. 無料の Apple ID で署名した場合、約 7 日で期限が切れます。切れたら、手順 4 からやり直します。

メモ

- `project.yml` の `DEVELOPMENT_TEAM` は、このリポジトリ作者のチームが入っています。`xcodegen generate` を実行すると、その値に戻ります。戻ったあとは、手順 3 で Team を選び直してください。

## 開発

- ファイルを追加・削除したときは、`xcodegen generate` を実行します。XcodeGen は `brew install xcodegen` で入ります。
- テストは iOS Simulator で実行します。

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
| `docs/` | 設計 spec と実装計画 |
| `project.yml` | XcodeGen の定義。`PipAwake.xcodeproj` はここから生成する |

## 公開サイト（Web/）

`main` に push すると `.github/workflows/pages.yml` が動き、サイトを GitHub Pages へ公開します。サイトには ipa を置いていません。

ローカルでサイトを作る場合:

```bash
cd Web
xcrun swift run PipAwakeWeb   # 生成物は Web/Build
```

- Swift 6.0 以上と macOS 14 以上が必要です。
- Xcode に付属の Swift（`xcrun swift`）を使ってください。別にインストールした Swift 6.2 では依存パッケージのビルドがクラッシュしました。
- Pages の公開には、リポジトリの Settings > Pages で Source を GitHub Actions にします。
