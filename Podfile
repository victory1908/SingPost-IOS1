platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'RaptureXML'
    pod 'Realm'
end

def ios_pods
#    pod 'AFNetworking', '1.2.1'
#    pod 'AFRaptureXMLRequestOperation'
    pod 'AFNetworking'
#    pod 'GoogleAnalytics-iOS-SDK'
    pod 'Google/Analytics'
#    pod 'GoogleAnalytics'
    pod 'KGModal'
    pod 'MagicalRecord'
    pod 'MHNatGeoViewControllerTransition'
    pod 'SVProgressHUD'
    pod 'UALogger'
    pod 'Reachability'
    pod 'RegexKitLite'
#    pod 'SSKeychain'
    
    pod 'SAMKeychain'
    
    pod 'TTTAttributedLabel'
    pod 'TPKeyboardAvoiding'
    pod 'UIAlertView+Blocks'
    pod 'UIActivityIndicator-for-SDWebImage'
    pod 'SevenSwitch'
#    pod 'ZXingObjC'
#    pod 'DeviceUtil'
#    pod 'MBProgressHUD'
#    pod 'RMUniversalAlert'
    pod 'CustomIOSAlertView'
#    pod 'Toast'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
#    pod 'Firebase/Crash'
    pod 'Firebase/AdMob'
    pod 'Firebase/Messaging'

end

def watch_pods
    
end

target 'SingPost' do
    shared_pods
    ios_pods
end

target 'SingPost WatchKit Extension' do
    shared_pods
    watch_pods
end

target 'SingPost WatchKit App' do
    shared_pods
    watch_pods
end
