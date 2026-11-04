import Foundation
import Ignite

struct PipAwakeSite: Site {
    var name = "PiP Awake"
    var titleSuffix = " | PiP Awake"
    var url = URL(string: "https://akidon0000.github.io/pip-awake/")!
    var homePage = HomePage()
    var layout = MainLayout()
}

@main
struct PipAwakeWebsite {
    static func main() async {
        do {
            var site = PipAwakeSite()
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}
