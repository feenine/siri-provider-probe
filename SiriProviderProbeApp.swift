import SwiftUI
import AppIntents

@main
struct SiriProviderProbeApp: App {
    var body: some Scene {
        WindowGroup { ProbeView() }
    }
}

private struct ProbeView: View {
    @State private var status = "尚未读取"

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Siri 接入探针").font(.title)
            Text("此 App 仅测试系统是否允许接入。打开本页面不代表 Siri 已能调用。")
            Button("读取系统接入状态") {
                status = String(reflecting: SiriProviderProbeIntent.enabledStatus)
            }
            Text(status).font(.footnote).textSelection(.enabled)
            Text("只有从 Siri 原界面收到固定测试标记，才证明接入测试通过。标记不是 GPT 回答。")
                .font(.footnote)
            Text("这是独立、可卸载的测试 App。它不联网、不读取令牌，不修改系统配置。")
                .font(.footnote)
        }
        .padding(24)
    }
}
