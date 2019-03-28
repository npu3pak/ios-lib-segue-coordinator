# SegueCoordinator

[![Version](https://img.shields.io/cocoapods/v/SegueCoordinator.svg?style=flat)](http://cocoapods.org/pods/SegueCoordinator)
[![License](https://img.shields.io/cocoapods/l/SegueCoordinator.svg?style=flat)](http://cocoapods.org/pods/SegueCoordinator)
[![Platform](https://img.shields.io/cocoapods/p/SegueCoordinator.svg?style=flat)](http://cocoapods.org/pods/SegueCoordinator)

It is alternative to Application Coordinator pattern.

### Separate navigation from view controllers

Controllers no longer need to know anything about other controllers and navigation. If the controller needs to show some data in another controller, it calls a closure and passes data into it. SegueCoordinator handles this closure, shows the desired controller and populates it with data.

### Remove the boilerplate code

SegueCoordinator allows you to perform typical navigation tasks like  push, segue, modal in a compact and consistent manner. Also, you can create multiple coordinators for different busines processes and reuse them. SegueCoordinator can become good entry point for this processes.

## Requirements
- iOS 9+
- Swift 5
- XCode 10.2+

## Installation

SegueCoordinator is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SegueCoordinator', :git => 'https://github.com/npu3pak/ios-lib-segue-coordinator.git'
```

## Usage

### 1. Prepare controllers

Create Main.storyboard with initial ListViewController and DetailsViewController. Add segue with identifier "ShowDetails" from list to details.

```swift
class ListViewController: UIViewController {

    var onShowDetails: ((String)->Void)?
    
    func showDetails() {
        onShowDetails?("Data")
    }
}

class DetailsViewController: UIViewController {

    var details: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // show details text here
    }
}
```
---
**IMPORTANT**

If you override prepareForSegue method, be sure to call super.prepareForSegue

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
}
```
---

### 2. Create coordinator
```swift
import SegueCoordinator

class MainCoordinator: SegueCoordinator {
    init(rootNavigationController: UINavigationController) {
        super.init(storyboardName: "Main", rootNavigationController: rootNavigationController)
    }

    func start() {
        setInitial(type: ListViewController.self) {
            $0.showDetails =  { [unowned self] in self.showDetails($0) }
        }
    }
    
    func showDetails(_ details: String) {
        segue("ShowDetails", type: DetailsViewController.self) {
            $0.data = details
        }
    }
}
```

### 3. Configure AppDelegate
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootNavigationController = UINavigationController()
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        mainCoordinator = MainCoordinator(rootNavigationController: rootNavigationController)
        mainCoordinator?.start()
        return true
    }
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory.

## Author

Evgeniy Safronov, evsafronov.personal@yandex.ru

## License

SegueCoordinator is available under the MIT license. See the LICENSE file for more info.
