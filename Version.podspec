Pod::Spec.new do |s|
  s.name = 'Version'
  s.version = '2.0.1'
	s.summary = 'A µ-framework for representing, comparing, encoding and utilizing semantic versions.'
	
	s.license = { :type => 'Apache', :file => 'LICENSE'}
	
	s.author = { 'Max Howell' => 'mxcl@me.com' }
	s.homepage = 'https://github.com/mxcl/Version'
	
	s.source = { :git => 'https://github.com/mxcl/Version.git', :tag => s.version.to_s }
	s.documentation_url = 'https://mxcl.dev/Version/Structs/Version.html'

	s.swift_versions = ['4.2', '5.0', '5.1', '5.2', '5.3']
	s.source_files = 'Sources/**/*.swift'
	s.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'dev.mxcl.version' }
	
	s.ios.deployment_target = '14.0'
	s.osx.deployment_target = '11.0'
end