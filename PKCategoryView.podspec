#
#  Be sure to run `pod spec lint PKCategoryView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

s.name         = "PKCategoryView"
s.version      = "0.1.2"
s.summary      = "A Swift based helper class that helps to create dynamic UITabBarController."

s.description  = <<-DESC
PKCategoryView helps you to create dynamic UITabBarController, that will manage be managed on scrolling or tap on the tab.
DESC

s.homepage     = "https://github.com/bestiosdeveloper/PKCategoryView"
s.screenshots  = "https://github.com/bestiosdeveloper/PKCategoryView/blob/master/PKCategoryViewDemo/static.gif"

s.license      = { :type => 'MIT', :file => 'LICENSE' }

s.author             = { "Pramod Kumar" => "kumarpramod017@gmail.com" }
s.social_media_url   = "http://pramodkumar.tk/"

s.ios.deployment_target = "11.0"

s.swift_version = "4.0"

s.source       = { :git => "https://github.com/bestiosdeveloper/PKCategoryView.git", :tag => "#{s.version.to_s}" }
s.source_files  = 'PKCategoryViewDemo/PKCategoryView/*.swift'

end

