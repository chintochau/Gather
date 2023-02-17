# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Gather Pool' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for gathering


  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'SDWebImage'
  pod 'IGListKit', '~> 4.0.0'
  pod 'EmojiPicker', :git => 'https://github.com/htmlprogrammist/EmojiPicker'
  pod 'Hero'
  pod 'PubNubSwift', '~> 6.0.3'

    # Pods for Instagram

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
    
  end
