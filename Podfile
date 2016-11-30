platform :ios, '8.0'
use_frameworks!

def shared_pods
    pod 'RaptureXML'
    pod 'Realm'
end

def ios_pods

    pod 'AFNetworking'
    pod 'Google/Analytics'
#    pod 'GoogleAnalytics'
    pod 'KGModal'
    pod 'MagicalRecord'
    pod 'MHNatGeoViewControllerTransition'
    pod 'SVProgressHUD'
    pod 'UALogger'
    pod 'Reachability'
    pod 'RegexKitLite'
    pod 'FDKeychain'

    pod 'TTTAttributedLabel'
    pod 'TPKeyboardAvoiding'
#    pod 'UIAlertView+Blocks'
    pod 'UIAlertController+Blocks'
    pod 'UIActivityIndicator-for-SDWebImage'
    pod 'SevenSwitch'
#    pod 'MBProgressHUD'
#    pod 'RMUniversalAlert'
    pod 'CustomIOSAlertView'
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
