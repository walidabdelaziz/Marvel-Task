# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


target 'Marvel Task' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marvel Task
  pod 'Kingfisher'
  pod 'Alamofire', '~> 4.7'
  pod 'SwiftyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RealmSwift', '~> 10.14.0'
  pod 'NVActivityIndicatorView'
  pod 'ReachabilitySwift'


end
post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
		end
	end
end