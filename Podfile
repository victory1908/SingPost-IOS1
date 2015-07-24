platform :ios, '7.0'

def shared_pods
    pod 'RaptureXML'
    pod 'Realm'
end

def ios_pods
    pod 'AFNetworking', '1.2.1'
    pod 'AFRaptureXMLRequestOperation', '1.0.2'
    pod 'GoogleAnalytics-iOS-SDK', '~> 3.0.9'
    pod 'KGModal', '~> 0.0.1'
    pod 'MagicalRecord'
    pod 'MHNatGeoViewControllerTransition', '~> 1.0'
    pod 'SVProgressHUD', '~> 1.0'
    pod 'UALogger', '~> 0.2.3'
    pod 'Reachability', '~> 3.1.1'
    pod 'RegexKitLite', '~> 4.0'
    pod 'SSKeychain', '~> 1.2.1'
    pod 'TTTAttributedLabel'
    pod 'TPKeyboardAvoiding', '~> 1.1'
    pod 'UIAlertView+Blocks', '~> 0.7'
    pod 'UIActivityIndicator-for-SDWebImage', '~> 1.0.3'
    pod 'SevenSwitch', '~> 1.3.0'
    pod 'ZXingObjC', '~> 3.0'
    pod 'DeviceUtil', '~> 1.2'
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