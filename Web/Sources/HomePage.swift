import Ignite

struct HomePage: StaticPage {
    var title = "PiP Awake"

    var body: some HTML {
        Section {
            Text("PiP Awake")
                .font(.title1)
            Text("iPhone の画面を点けたままにするための iOS アプリです。PiP で経過時間の映像を再生し続けます。")
            Text("ipa は未署名です。Sideloadly や AltStore で、自分の Apple ID を使ってインストールしてください。")
            Link("PipAwake.ipa をダウンロード", target: "PipAwake.ipa")
                .linkStyle(.button)
        }
        .padding(.vertical, 40)
    }
}
