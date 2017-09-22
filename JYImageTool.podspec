Pod::Spec.new do |s|
  s.name         = 'JYImageTool'
  s.summary      = '🛠Useful image tools for iOS.'
  s.version      = '2.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Job-Yang" => "578093143@qq.com" }
  s.social_media_url = 'http://www.jianshu.com/users/cf7e85326534/latest_articles'
  s.homepage     = 'https://github.com/Job-Yang/JYImageTool'
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => 'https://github.com/Job-Yang/JYImageTool.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'JYImageTool/**/*.{h,m}'
  
  s.frameworks = 'UIKit'
  
end
