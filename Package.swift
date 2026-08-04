// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodelyticalLivenessSilentSDK",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CodelyticalLivenessSilentSDK",
            targets: ["CodelyticalLivenessSilentSDK", "CodelyticalLivenessSilentSDKResources"]
        )
    ],
    targets: [
        // Compiled code (source stays private) — the target name must match
        // the module name baked into the xcframework, since that's what
        // `import CodelyticalLivenessSilentSDK` resolves to.
        .binaryTarget(
            name: "CodelyticalLivenessSilentSDK",
            url: "https://github.com/CodeLytialHub/liveness-silent-ios/releases/download/1.0.1/CodelyticalLivenessSilentSDK.xcframework.zip",
            checksum: "5b26a5806a72860bb6a4433502a2fbcd8d77ea325e9427ffb91e16768f924eeb"
        ),
        // ncnn model weights (.bin/.param) + config.json. These aren't
        // sensitive the way the Swift/C++ source is — the Android build
        // already ships the identical files inside its APK assets — so
        // they're checked into this repo as plain files rather than a
        // release download, and SwiftPM compiles them into a Bundle.module
        // the SDK discovers at runtime (see LivenessResourceBundle).
        .target(
            name: "CodelyticalLivenessSilentSDKResources",
            path: "Sources/CodelyticalLivenessSilentSDKResources",
            resources: [.copy("Resources")]
        )
    ]
)
