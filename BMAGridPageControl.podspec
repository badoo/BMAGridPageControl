Pod::Spec.new do |s|
  s.name             = "BMAGridPageControl"
  s.version          = File.read('VERSION')
  s.summary          = "A page control to hint users that elements are in fact part of a grid"
  s.homepage         = "http://www.hotornot.com"
  s.license          = { :type => 'MIT' }
  s.author           = { "Miguel Angel Quinones" => "miguel.quinones@corp.badoo.com" }
  s.source           = { :git => "https://github.com/badoo/BMAGridPageControl.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hotornot'

   s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'BMAGridPageControl'
end
