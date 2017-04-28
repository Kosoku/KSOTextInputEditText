#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOTextInputEditText'
  s.version          = '0.5.0'
  s.summary          = 'KSOTextInputEditText is an iOS framework for Android Material Design TextInputEditText styled UITextFields.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSOTextInputEditTextField is a KDITextField subclass that adds a floating label and styling comparable to the TextInputEditText UI Component found in Android Material Design.
 https://material.io/guidelines/components/text-fields.html#text-fields-field-types
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOTextInputEditText'
  s.screenshots      = ['https://github.com/Kosoku/KSOTextInputEditText/raw/master/screenshots/KSOTextInputEditText.gif']
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'Jason R. Anderson' => 'jason@kosoku.com', 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOTextInputEditText.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'KSOTextInputEditText/**/*.{h,m}'
  s.exclude_files = 'KSOTextInputEditText/KSOTextInputEditText-Info.h'
  s.private_header_files = 'KSOTextInputEditText/Private/*.h'
  
  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }

  s.frameworks = 'UIKit'
  
  s.dependency 'Ditko'
  s.dependency 'Stanley'
end
