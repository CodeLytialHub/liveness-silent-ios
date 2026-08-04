/// Empty on purpose — this target exists only to carry the ncnn model files
/// (see `Resources/`) into a Bundle.module Swift Package Manager can build
/// and embed; SwiftPM's resource bundling wants at least one source file in
/// the target that owns the `resources:` declaration.
enum CodelyticalLivenessSilentSDKResourcesMarker {}
