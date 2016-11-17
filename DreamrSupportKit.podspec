#
# Be sure to run `pod lib lint DreamrSupportKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'DreamrSupportKit'
s.version          = '1.1.1'
s.summary          = 'A set of view controllers providing a customer feedback feature'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
    DreamrSupportKit is a reusable and customisable package containing a set of view controllers
    that combine to provide a customer feedback feature.
DESC

s.homepage         = 'https://gitlab.com/projects.dreamr.uk/DreamrSupportKit-iOS.git'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Ryan Willis' => 'rw@dreamr.uk' }
s.source           = { :git => 'https://gitlab.com/projects.dreamr.uk/DreamrSupportKit-iOS.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '9.0'

s.source_files = 'DreamrSupportKit/Classes/**/*'

s.resources = ['DreamrSupportKit/Media.xcassets']

# s.resource_bundles = {
#   'DreamrSupportKit' => ['DreamrSupportKit/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
