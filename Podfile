# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'Sportster' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Sportster
  
  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  # https://firebase.google.com/docs/ios/setup#available-pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'

  target 'SportsterTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SportsterUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
  
end
