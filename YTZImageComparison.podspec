Pod::Spec.new do |s|
  s.name         = 'YTZImageComparison'
  s.summary      = 'Image compariosn recognition framework.'
  s.version      = '1.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Job-Yang" => "578093143@qq.com" }
  s.social_media_url = 'http://www.jianshu.com/users/cf7e85326534/latest_articles'
  s.homepage     = 'https://github.com/Job-Yang/YTZImageComparison'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/Job-Yang/YTZImageComparison.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'YTZImageComparison/**/*.{h,m}'
  s.public_header_files = 'YTZImageComparison/**/*.{h}'
  
  s.frameworks = 'UIKit'
  
end
