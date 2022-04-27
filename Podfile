# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
inhibit_all_warnings!

target 'TGObjcDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'ReactiveObjC'
  pod 'AFNetworking'
  pod 'MJRefresh'
  pod 'SDWebImage'
  pod 'MJExtension'
  pod 'YYModel'
  pod 'MLeaksFinder',:configurations => ['Debug']
  pod 'SSKeychain'
  
  # pod git 上master分支的版本
  #pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
  # pod dev分支的版本库
  #pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :branch => 'dev'
  # pod 指定tag的库
  #pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.1.1'
  # pod 指定commit号版本
  #pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :commit => '0f506b1c45'
  # pod 'JSONKit', :podspec => 'https://example.com/JSONKit.podspec'
  # pod 'xxxx', :path => '/Users/xxxx/xxxx/xxxx/xxxxx.podspec'

  target 'TGObjcDemoTests' do
    pod 'ReactiveObjC'
  end
  
  require "fileutils"
    
    post_install do |installer|
      installer.pods_project.targets.each do | target |
        installer.pods_project.build_configurations.each do |config|
          config.build_settings["SWIFT_VERSION"] = "4.2"
          config.build_settings["VALID_ARCHS"] = "arm64 arm64e x86_64"
          config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "10.0"
          config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
      end
      ## Fix for XCode 12.5
      find_and_replace("Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm",
            "layoutCache[currentClass] = ivars;", "layoutCache[(id<NSCopying>)currentClass] = ivars;")
    end

    def find_and_replace(dir, findstr, replacestr)
      Dir[dir].each do |name|
          FileUtils.chmod("+w", name) #add
          text = File.read(name)
          replace = text.gsub(findstr,replacestr)
          if text != replace
              puts "Fix: " + name
              File.open(name, "w") { |file| file.puts replace }
              STDOUT.flush
          end
      end
      Dir[dir + '*/'].each(&method(:find_and_replace))
    end
  
end
