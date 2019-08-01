#
#  Be sure to run `pod spec lint JLKit_Swift.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name          = 'JLKit_Swift'
    s.version       = '0.0.30'
    s.summary       = 'JLKit'
    s.homepage      = 'https://github.com/jangsy7883/JLKit_Swift'
    s.license       = { :type => 'MIT', :file => 'LICENSE' }
    s.author        = { 'jangsy' => 'jangsy7883@gmail.com' }
    s.source        = { :git => 'https://github.com/jangsy7883/JLKit_Swift.git', :tag => s.version.to_s }
    s.platform      = :ios, '9.0'
    s.swift_version = '5.0'

    s.default_subspec = 'Core'

    s.subspec 'Core' do |sp|
        sp.source_files = 'JLKit/Extensions/Foundation/','JLKit/Extensions/UIKit/', 'JLKit/Protocols/'
    end

    s.subspec 'Objcs' do |sp|
        sp.source_files = 'JLKit/Objcs/', 'JLKit/Objcs/Foundation/','JLKit/Objcs/UIKit/'
        sp.dependency 'JLKit_Swift/Core'
    end

    s.pod_target_xcconfig = { 'APPLICATION_EXTENSION_API_ONLY' => 'NO' }
end
