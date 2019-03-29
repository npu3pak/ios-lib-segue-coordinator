#
# Be sure to run `pod lib lint SegueCoordinator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SegueCoordinator'
  s.version          = '0.8.0'
  s.summary          = 'Keeps your navigation logic separated'
  s.homepage         = 'https://github.com/npu3pak/ios-lib-segue-coordinator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evgeniy Safronov' => 'evsafronov.personal@yandex.ru' }
  s.source           = { :git => 'https://github.com/npu3pak/ios-lib-segue-coordinator.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SegueCoordinator/Classes/**/*'

  s.description      = <<-DESC
It is alternative to Application Coordinator pattern.

1. Separates navigation from view controllers.
Controllers no longer need to know anything about other controllers and navigation. If the controller needs to show some data in another controller, it calls a closure and passes data into it. SegueCoordinator handles this closure, shows the desired controller and populates it with data.

2. Removes the boilerplate code.
SegueCoordinator allows you to perform typical navigation tasks like  push, segue, modal in a compact and consistent manner. Also, you can create multiple coordinators for different busines processes and reuse them. SegueCoordinator can become good entry point for this processes.
                       DESC

end
