#
# Be sure to run `pod lib lint SegueCoordinator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SegueCoordinator'
    s.version          = '0.8.1'
    s.summary          = 'Create separate classes that will handle navigation instead of view controllers'
    s.homepage         = 'https://github.com/npu3pak/ios-lib-segue-coordinator'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Evgeniy Safronov' => 'evsafronov.personal@yandex.ru' }
    s.source           = { :git => 'https://github.com/npu3pak/ios-lib-segue-coordinator.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    s.swift_version = '5.0'
    s.source_files = 'SegueCoordinator/Classes/**/*'

    s.description      = <<-DESC
    Alternative to Application Coordinator pattern. Create separate classes that will handle navigation instead of view controllers.
    DESC

end
