
Pod::Spec.new do |s|

  s.name = 'Version'
  s.version = '1.2.0'
  s.swift_version = '5'
  s.summary = 'semver (Semantic Version) Swift µFramework.'
  s.homepage = 'https://github.com/mxcl/Version'
  s.authors = { 'Max Howell' => 'mxcl@me.com' }
  s.license = { :type => 'Apache Licence 2.0', :file => 'LICENSE' }
  s.source = { :git => 'https://github.com/mxcl/Version.git', :tag => s.version.to_s }
  s.source_files = 'Sources/*'

end

