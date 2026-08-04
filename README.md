# CodelyticalLivenessSilentSDK

<p align="center">
  <strong>Face liveness detection for iOS — drop-in, automatic, on-device.</strong><br/>
  Powered by ncnn and the Silent-Face-Anti-Spoofing (MiniFASNet) model ensemble.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-17.0%2B-blue?style=flat-square" />
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=flat-square" />
  <img src="https://img.shields.io/badge/CocoaPods-1.0.0-red?style=flat-square" />
  <img src="https://img.shields.io/badge/SPM-supported-brightgreen?style=flat-square" />
  <img src="https://img.shields.io/badge/License-Commercial-lightgrey?style=flat-square" />
</p>

---

## What It Does

CodelyticalLivenessSilentSDK gives your iOS app a fully automatic face liveness screen. The user opens the screen, looks at the camera, and the SDK determines within seconds whether it is a real person or a spoof (photo, screen, mask).

- No capture button — fully automatic
- On-device detection — face data never leaves the phone until capture
- SwiftUI-native — one line to present
- Works with CocoaPods **and** Swift Package Manager

---

## Requirements

- iOS 17.0+
- Xcode 16+
- A CodeLytical API key (see below)

---

## Step 1 — Get Your API Key

1. Go to **[https://www.codelyticalhub.com](https://www.codelyticalhub.com)**
2. Create an account or sign in
3. Navigate to the **Dashboard → API Keys**
4. Click **Generate Key**
5. Copy your key — it starts with `fg_live_`

Keep your key private. Do not commit it to a public repository.

---

## Step 2 — Installation

### CocoaPods

```ruby
pod 'CodelyticalLivenessSilentSDK', '~> 1.0.0'
```

```bash
pod install
```

Open your project using the `.xcworkspace` file from now on.

### Swift Package Manager

Xcode → **File → Add Package Dependencies…** → paste:

```
https://github.com/CodeLytialHub/liveness-silent-ios
```

Or in `Package.swift`:

```swift
.package(url: "https://github.com/CodeLytialHub/liveness-silent-ios", from: "1.0.0")
```

---

## Step 3 — Camera Permission

Add this to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app uses the camera to perform face liveness detection.</string>
```

Without this the app will crash when the SDK tries to access the camera.

---

## Step 4 — Integration

### Import the SDK

```swift
import CodelyticalLivenessSilentSDK
```

### Initialize (validate your API key)

Call this **once on app launch**. It validates your key against the CodeLytical portal.

```swift
LivenessSdk.validate(apiKey: "fg_live_YOUR_KEY_HERE") { success, error in
    if success {
        print("SDK ready")
    } else {
        print("Error: \(error ?? "Invalid key")")
    }
}
```

`validate` also takes an optional `baseURL`, defaulting to `LivenessSdk.defaultBaseURL` (CodeLytical's current portal domain). You won't normally need to touch this — it's there so that if the portal ever moves to a new domain, you can point at it without waiting on an SDK update:

```swift
LivenessSdk.validate(
    apiKey: "fg_live_YOUR_KEY_HERE",
    baseURL: URL(string: "https://new-portal-domain.codelyticalhub.com")!
) { success, error in ...
```

The callback is always called on the **main thread**.

### Present the Liveness Screen

```swift
.fullScreenCover(isPresented: $showLiveness) {
    LivenessScannerView { result in
        showLiveness = false

        switch result {
        case .real(let imageURL, let confidence):
            // Genuine live face detected
            print("Real face — confidence: \(confidence)")

        case .spoof:
            // Spoof detected, or no face appeared within the timeout
            print("Spoof detected")

        case .cancelled:
            // User tapped the close button
            print("Cancelled")

        case .error(let message):
            // Camera unavailable, model load failure, capture error, etc.
            print("Error: \(message)")
        }
    }
}
```

You can tune the scan with `LivenessConfig` (capture delay, confidence threshold, whether to capture a photo at all, whether to also flag phone/screen replay attempts):

```swift
LivenessScannerView(config: LivenessConfig(threshold: 0.96)) { result in ... }
```

---

## Full Example

```swift
import SwiftUI
import CodelyticalLivenessSilentSDK

struct ContentView: View {
    private let apiKey = "fg_live_YOUR_KEY_HERE"

    @State private var ready = false
    @State private var status = "Validating API key…"
    @State private var isScanning = false
    @State private var resultText: String?
    @State private var faceImage: UIImage?

    var body: some View {
        VStack(spacing: 16) {
            Text("CodeLytical Liveness Demo").font(.title2.bold())
            Text(status).foregroundStyle(.secondary)

            Button("Start Liveness Check") {
                resultText = nil
                faceImage = nil
                isScanning = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(!ready)

            if let resultText { Text(resultText) }
            if let faceImage {
                Image(uiImage: faceImage)
                    .resizable().scaledToFill()
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(24)
        .task {
            LivenessSdk.validate(apiKey: apiKey) { ok, error in
                ready = ok
                status = ok ? "SDK ready" : (error ?? "Invalid API key")
            }
        }
        .fullScreenCover(isPresented: $isScanning) {
            LivenessScannerView { result in
                isScanning = false
                switch result {
                case .real(let url, let confidence):
                    resultText = String(format: "✅ Genuine face (confidence %.3f)", confidence)
                    if let url { faceImage = LivenessSdk.image(at: url) }
                case .spoof:
                    resultText = "⚠️ Spoof / no live face detected"
                case .cancelled:
                    resultText = "Cancelled by user"
                case .error(let message):
                    resultText = "Error: \(message)"
                }
            }
        }
    }
}
```

---

## Result Reference

| Case                       | When it fires                                                  |
| -------------------------- | ---------------------------------------------------------------|
| `.real(imageURL, confidence)` | A genuine live face was confirmed (and captured, if enabled) |
| `.spoof`                   | A spoof was detected, screen/photo replay, or no face in time  |
| `.cancelled`                | The user tapped the ✕ close button                             |
| `.error(String)`           | Camera unavailable, model load failure, or capture error       |

---

## Privacy

All face detection and anti-spoofing runs **entirely on-device** via ncnn. No video frames or biometric data are sent anywhere. Only the final captured JPEG is available to your app — and only if the result is `.real` and `shouldCapture` is enabled.

---

## Support

- Website: [https://www.codelyticalhub.com](https://www.codelyticalhub.com)
- Email: codelyticalhub@gmail.com

---

## License

Commercial. Copyright © CodeLytical. All rights reserved.
Redistribution, reverse engineering, or resale of this SDK is strictly prohibited.
