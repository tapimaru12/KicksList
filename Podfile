# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end
end

target 'KicksList' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'RealmSwift'
  
  # Pods for KicksList
  
  target 'KicksListTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'KicksListUITests' do
    # Pods for testing
  end
  
end
