Pod::Spec.new do |s|
  s.name             = 'LongRange'
  s.version          = '0.9'
  s.license = 'MIT'

  s.summary          = 'Library for displaying long ranges on Apple Maps.'

  s.description      = <<-DESC
Long Range helps you display range for objects (e.g. aircraft) on the map.
                       DESC

  s.homepage         = 'https://github.com/suvov/LongRange'
  s.author           = { 'Vladimir Shutyuk' => 'shookup@gmail.com' }
  s.source           = { :git => 'https://github.com/suvov/LongRange.git', :tag => s.version.to_s }

  s.source_files = 'Source/*.swift'
  s.ios.deployment_target = '8.0'
end
