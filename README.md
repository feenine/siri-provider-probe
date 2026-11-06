# Siri Provider Probe — experimental, unsigned iOS candidate

This small standalone app tests whether an iOS 27 system can discover a model-delegation intent and show its fixed response inside the original Siri interface. It does not call GPT, use credentials, connect to a server, change system settings, or declare a private entitlement. It uses its own bundle identifier: `org.codexresearch.SiriProviderProbe`.

**Source code, a successful build, installation, and an app status screen are not proof of Siri integration.** The first integration milestone requires an invocation from the original Siri entry point with the fixed marker displayed in the original Siri interface. Even that milestone does not prove GPT replacement.

## Interface provenance and uncertainty

The experimental handler signature and status API follow the inspected [OpenClawKit implementation at commit 3d24fd5ffea2285718b99eb4ae3c2f86163d1bb5](https://github.com/MarcoDotIO/OpenClawKit/blob/3d24fd5ffea2285718b99eb4ae3c2f86163d1bb5/Sources/OpenClawAppIntents/OpenClawModelDelegationIntent.swift). Its experimental macOS CI record is not an iPhone acceptance record.

`_ModelDelegationIntent` is an undocumented API. Availability and signatures may change between SDK versions. The host-only app declaration is a hypothesis; discovery may require another packaging format or a platform-granted entitlement. Failure of this candidate does not establish that every iOS integration route is impossible. Ordinary app signing does not grant special system permissions.

## Build

Use an officially supported Mac with Xcode 27 or later. Check [Apple's Xcode requirements](https://developer.apple.com/xcode/system-requirements) for the selected version.

```bash
bash ./build-unsigned.sh
```

The script writes only to this project's `build/` and `dist/` directories. It disables code signing, records the actual toolchain, and produces `dist/SiriProviderProbe-unsigned.ipa` only after a successful iPhone-device build and an executable-file check. It neither signs nor installs the app. A normally signed package is required for a device installation attempt.

The included GitHub Actions workflow is manual-only (`workflow_dispatch`). It uses the standard `xcode-27` runner and selects Xcode 27.1 from the [official image manifest](https://github.com/actions/runner-images/blob/main/images/macos/xcode-27-arm64-Readme.md). The actual SDK version is logged; it must not be described as a build against a newer SDK. A runner image update or unavailable preview image can cause a build failure.

- The job has a 15-minute timeout and read-only repository permissions.
- Only public repositories run this workflow, so it does not consume private-repository compute allowance. [GitHub billing rules](https://docs.github.com/en/actions/concepts/billing-and-usage).
- It does not require Secrets, Apple credentials, signing certificates, device identifiers, or GPT credentials.
- Uploaded build artifacts expire after one day. Workflow logs follow the repository's own retention setting and are public in a public repository.
- Build failure logs are preserved when the upload step can run; no artifact is guaranteed after runner loss or forced cancellation.

## Device acceptance procedure — not yet executed

1. Review the actual built IPA, executable, bundle identifier, App Intents metadata, and file list. Check that it contains only the expected app, with no configuration profile, certificate installer, VPN, MDM, or account request. Hash the unsigned package and the final signed package separately.
2. Sign using an ordinary supported signing method. Do not reuse another installed app's identity or add unauthorized entitlements. Do not change system identity, restore a modified backup, jailbreak, disable protection, or enroll the device in management to make this candidate work.
3. Install the reviewed signed app. The status button reads the system-provided status; opening the app or displaying that status is not native integration success.
4. Check the original Siri/model-provider settings for the probe. If absent, record the exact absence, system status, signing information, and available diagnostic evidence. Do not substitute a Shortcut or a separate app launch.
5. If the probe is discoverable and selectable, invoke it from the original Siri entry point with a non-private test request. The expected text begins `SIRI-PROVIDER-PROBE-24C5037I-V1` and explicitly states that it is a connection test, not a GPT answer. Record the original interface and the time.
6. A displayed marker establishes only the integration channel. A later GPT-backed candidate must separately prove that GPT actually handled the request and that its answer appeared in the original interface. GPT authorization must remain on the user-controlled runtime.
7. Compare ordinary Siri tasks, cancellation, locked and unlocked use, restart, signature expiry, and uninstall recovery. This offline probe cannot establish the latency, network-failure behavior, conversation handling, or image/file support of a future network-backed implementation.

The repository is a buildable-candidate experiment, not a claim of a working default model or search replacement. Consult the actual workflow result before describing compilation as successful.
