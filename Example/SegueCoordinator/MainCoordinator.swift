
import SegueCoordinator

class MainCoordinator: SegueCoordinator {

    init(rootNavigationController: UINavigationController) {
        super.init(storyboardName: "Main", rootNavigationController: rootNavigationController)
    }

    func start() {
        // Fill empty rootNavigationController with initial view controller of storyboard
        setInitial(type: RootViewController.self) {
            // Controllers are captured by SegueCoordinator in rootNavigationController.
            // You should use weak/unowned to avoid memory leaks
            $0.showFirst =  { [unowned self] in self.showFirst() }
            $0.showSecond =  { [unowned self] in self.showSecond() }
            $0.showThird =  { [unowned self] in self.showThird() }
        }
    }
    
    func showFirst() {
        // Perform segue with identifier "ShowFirst"
        segue("ShowFirst", type: FirstViewController.self) {
            // Initialize controller. This it prepareForSegue replacement
            $0.title = "First"
            $0.onShowSecond = { [unowned self] in self.showSecondFromFirst() }
        }
    }
    
    func showSecondFromFirst() {
        segue("ShowSecond", type: SecondViewController.self) {
            $0.title = "Second"
        }
    }
    
    func showSecond() {
        // Push controller with identifier "Second"
        push("Second", type: SecondViewController.self) {
            $0.title = "Second"
        }
    }
    
    func showThird() {
        // Display controller with identifier "Third" modally
        modal("Third", type: ThirdViewController.self, style: .formSheet) {
            $0.onCancel = { [unowned self] in self.closeModal() }
            $0.onShowFourthWithPush = { [unowned self] in self.showFourthWithPush() }
            $0.onShowFourthWithSegue = { [unowned self] in self.showFourthWithSegue() }
            $0.title = "Third"
        }
    }

    func showFourthWithPush() {
        // Push from modal controller
        push("Fourth", type: FourthViewController.self) {
            $0.title = "Fourth"
            $0.onUnwindToRoot = { self.unwindToFirst(type: RootViewController.self) }
            $0.onUnwindToThird = { self.unwindToFirst(type: ThirdViewController.self) }
            $0.onUnwindToFourth = { self.unwindToFirst(type: FourthViewController.self) }
            $0.onUnwindToFirstNavigation = { self.unwindToFirst(type: UINavigationController.self) }
        }
    }

    func showFourthWithSegue() {
        // Push from modal controller
        segue("ShowFourth", type: FourthViewController.self) {
            $0.title = "Fourth"
            $0.onUnwindToRoot = { self.unwindToFirst(type: RootViewController.self) }
            $0.onUnwindToThird = { self.unwindToFirst(type: ThirdViewController.self) }
            $0.onUnwindToFourth = { self.unwindToFirst(type: FourthViewController.self) }
            $0.onUnwindToFirstNavigation = { self.unwindToFirst(type: UINavigationController.self) }
        }
    }
}
