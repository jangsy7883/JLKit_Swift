#
#  Be sure to run `pod spec lint JLKit_Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name          = 'JLKit_Swift'
    s.version       = '0.0.73'
    s.summary       = 'JLKit'
    s.homepage      = 'https://github.com/jangsy7883/JLKit_Swift'
    s.license       = { :type => 'MIT', :file => 'LICENSE' }
    s.author        = { 'jangsy' => 'jangsy7883@gmail.com' }
    s.source        = { :git => 'https://github.com/jangsy7883/JLKit_Swift.git', :tag => s.version.to_s }
    s.swift_version = '5.0'
    s.ios.deployment_target = '13.0'
    s.watchos.deployment_target = '6.0'
#    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.default_subspec = 'Core'

    s.subspec 'Core' do |sp|
        sp.source_files = 'JLKit/Extensions/Foundation/','JLKit/Extensions/UIKit/', 'JLKit/Extensions/SwiftStdlib/', 'JLKit/Protocols/', 'JLKit/Utils/'
        sp.ios.frameworks = 'Photos'
        
        # sp.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
        # sp.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    end

    s.subspec 'Objcs' do |sp|
        sp.source_files = 'JLKit/Objcs/', 'JLKit/Objcs/Foundation/','JLKit/Objcs/UIKit/'
        sp.dependency 'JLKit_Swift/Core'
        
#        sp.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#        sp.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    end
end
