# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'gathering' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for gathering


  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'SDWebImage'
  pod 'IGListKit', '~> 4.0.0'

    # Pods for Instagram

    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
    
  end