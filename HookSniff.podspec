Pod::Spec.new do |s|
  s.name         = 'HookSniff'
  s.version      = '1.2.0'
  s.summary      = 'HookSniff webhooks SDK for Swift'
  s.description  = 'Official Swift SDK for the HookSniff webhook infrastructure platform. Send, receive, and verify webhooks.'
  s.homepage     = 'https://github.com/servetarslan02/hooksniff-swift'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'name' => 'HookSniff', 'email' => 'support@hooksniff.com' }
  s.source       = { :git => 'https://github.com/servetarslan02/hooksniff-swift.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'

  s.swift_version = '5.7'
  s.source_files  = 'HookSniffSDK/Sources/HookSniff/**/*.swift'
  s.frameworks    = 'Foundation'

  s.dependency 'Crypto', '~> 3.0'
end
