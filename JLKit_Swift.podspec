Pod::Spec.new do |s|
    s.name            = "JLKit_Swift"
    s.version         = "0.1"
    s.license         = { :type => 'MIT', :file => 'LICENSE' }
    s.summary         = "JLKit"
    s.homepage        = "https://github.com/jangsy7883/JLKit_Swift"
    s.author          = { "hmhv" => "jangsy7883@gmail.com" }
    s.source          = { :git => "https://github.com/jangsy7883/JLKit.git", :tag => s.version }
    s.platform        = :ios, '9.0'
    s.requires_arc    = true
    s.default_subspec = 'Core'

    s.subspec 'Core' do |core|
    core.dependency 'JLKit/Extensions'
    core.dependency 'JLKit/Protocols'
    core.source_files =  'Loggable.swift'
    
    end
end
