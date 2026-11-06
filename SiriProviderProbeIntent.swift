import Foundation
import AppIntents

// Experimental iOS 27 SPI. The handler shape follows the inspected, pinned
// OpenClawKit implementation; this standalone app has NOT been built or run.
// No private entitlement is claimed and no existing app identity is reused.
@available(iOS 27.0, *)
@_ModelDelegationIntent
public struct SiriProviderProbeIntent {
    public static let title: LocalizedStringResource = "Siri 接入探针"
    public static var supportedFeatures: _ModelDelegationFeatures { [.systemAssistant] }

    public init() {}

    public func perform(
        prompt: IntentPrompt,
        conversationIdentifier: String?,
        responseStream: IntentResponseStream<_ModelDelegationOutput>,
        configuration: _ModelDelegationConfiguration
    ) async throws -> _ModelDelegationResult {
        try Task.checkCancellation()
        responseStream.append(text: "SIRI-PROVIDER-PROBE-24C5037I-V1 — 仅接入测试，不是 GPT 回答。")
        return .complete()
    }
}
