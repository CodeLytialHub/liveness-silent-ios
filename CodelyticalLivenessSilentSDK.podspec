Pod::Spec.new do |s|
  s.name             = 'CodelyticalLivenessSilentSDK'
  s.version          = '1.0.3'
  s.summary          = 'Face liveness / anti-spoofing SDK for iOS (SwiftUI), on-device via ncnn.'
  s.description      = <<-DESC
    CodelyticalLivenessSilentSDK provides a drop-in SwiftUI face liveness
    screen backed by the Silent-Face-Anti-Spoofing (MiniFASNet) model
    ensemble, running fully on-device via ncnn. Online API-key validation,
    no capture button — fully automatic.
  DESC

  s.homepage         = 'https://www.codelyticalhub.com'
  s.license          = { :type => 'Commercial', :text => 'Copyright CodeLytical. All rights reserved.' }
  s.author           = { 'CodeLytical' => 'codelyticalhub@gmail.com' }
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.9'

  # A separate zip from the SPM binary target's — this one bundles the
  # xcframework *and* the model-resources bundle together, since CocoaPods
  # only supports a single :http source per spec and s.resources below needs
  # both to be present after extraction.
  s.source = {
    :http => 'https://github.com/CodeLytialHub/liveness-silent-ios/releases/download/1.0.3/CodelyticalLivenessSilentSDK-CocoaPods.zip'
  }

  s.vendored_frameworks = 'CodelyticalLivenessSilentSDK.xcframework'
  s.resources = 'CodelyticalLivenessSilentSDKResources.bundle'
  s.frameworks = 'AVFoundation', 'UIKit', 'CoreImage', 'CoreVideo', 'CoreMedia', 'Vision', 'QuartzCore'
end
