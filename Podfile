source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/SecretLisa/Specs.git'

platform :ios, '9.0'

inhibit_all_warnings!

def shared_pods
    pod 'JSONModel'
end

abstract_target 'default' do
    shared_pods
    target 'CallTest'
end

target 'MessageExtension' do
    pod 'JSONModel'
end
