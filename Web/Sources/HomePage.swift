import Ignite

struct HomePage: StaticPage {
    var title = "PiP Awake"

    var body: some HTML {
        Section {
            Text("PiP Awake")
                .font(.title1)
            Text("iPhone の画面を点けたままにするための iOS アプリです。PiP で経過時間の映像を再生し続けます。")
            Text("このアプリは ipa では配布していません。ソースを取得して Xcode でビルドし、自分の iPhone に入れてください。")
            Link("ソースとインストール手順（GitHub）", target: "https://github.com/akidon0000/pip-awake")
                .linkStyle(.button)
        }
        .padding(.vertical, 40)
    }
}
