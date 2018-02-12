//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//
//

import Foundation

open class SegueCoordinator: NSObject {
    public let storyboard: UIStoryboard
    public let rootNavigationController: UINavigationController
    public let rootViewControllerId: String?
    
    var controllerPreparationCallbacks: Dictionary<String, ((UIViewController) -> Void)> = [:]
    
    public init(storyboardName: String, bundle: Bundle = Bundle.main, rootNavigationController: UINavigationController, rootViewControllerId: String? = nil) {
        UIViewController.swizzlePrepareForSegue()
        
        self.rootNavigationController = rootNavigationController
        self.rootViewControllerId = rootViewControllerId
        storyboard = UIStoryboard.init(name: storyboardName, bundle: bundle)
        
        super.init()
    }
    
    public init(rootViewController: UIViewController) {
        UIViewController.swizzlePrepareForSegue()
        
        storyboard = rootViewController.storyboard!
        rootNavigationController = rootViewController.navigationController!
        rootViewControllerId = rootViewController.restorationIdentifier
        
        super.init()
        rootViewController.__segueCoordinator = self
    }
    
    //MARK: API
    
    //generic методы
    public func initialController() -> UIViewController {
        return storyboard.instantiateInitialViewController()!
    }
    
    public func instantiateController<T: UIViewController>(_ storyboardId: String, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    public func pushInitial<T: UIViewController>(type: T.Type, clearStack: Bool = false, prepareController: (T) -> Void) {
        pushInitial(clearStack: clearStack) {
            prepareController($0 as! T)
        }
    }
    
    public func modalInitial<T: UIViewController>(type: T.Type, style: UIModalPresentationStyle = .formSheet, prepareController: (T) -> Void) {
        modalInitial(style) {
            prepareController($0 as! T)
        }
    }
    
    public func modalOrPushInitial<T: UIViewController>(type: T.Type, clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (T) -> Void) {
        modalOrPushInitial(clearStack: clearStack, style: style) {
            prepareController($0 as! T)
        }
    }
    
    public func push<T: UIViewController>(_ controllerId: String, type: T.Type, clearStack: Bool = false, prepareController: (T) -> Void) {
        push(controllerId, clearStack: clearStack) {
            prepareController($0 as! T)
        }
    }
    
    public func modal<T: UIViewController>(_ controllerId: String, type: T.Type, style: UIModalPresentationStyle = .formSheet, prepareController: (T) -> Void) {
        modal(controllerId, style: style) {
            prepareController($0 as! T)
        }
    }
    
    public func modalOrPush<T: UIViewController>(_ controllerId: String, type: T.Type, clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (T) -> Void) {
        modalOrPush(controllerId, clearStack: clearStack, style: style) {
            prepareController($0 as! T)
        }
    }
    
    public func popoverOrPush<T: UIViewController>(_ controllerId: String, type: T.Type, anchor: UIBarButtonItem? = nil, prepareController: @escaping (T) -> Void) {
        popoverOrPush(controllerId, anchor: anchor) {
            prepareController($0 as! T)
        }
    }
    
    public func segue<T: UIViewController>(_ segueId: String, type: T.Type, prepareController: @escaping (T) -> Void) {
        segue(segueId) {
            prepareController($0 as! T)
        }
    }
    
    //Не generic методы
    public func pushInitial(clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }
    
    public func modalInitial(_ style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        modal(controller, style: style, prepareController: prepareController)
    }
    
    public func modalOrPushInitial(clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        modalOrPush(controller, clearStack: clearStack, style: style, prepareController: prepareController)
    }
    
    public func push(_ controllerId: String, clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId)
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }
    
    public func modal(_ controllerId: String, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId)
        modal(controller, style: style, prepareController: prepareController)
    }
    
    public func modalOrPush(_ controllerId: String, clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        if isPhone {
            push(controllerId, clearStack: clearStack, prepareController: prepareController)
        } else {
            modal(controllerId, style: style, prepareController: prepareController)
        }
    }
    
    private func push(_ controller: UIViewController, clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        controller.__segueCoordinator = self
        prepareController(controller)
        if clearStack {
            getCurrentNavigationController().viewControllers = [controller]
        } else {
            getCurrentNavigationController().pushViewController(controller, animated: true)
        }
    }
    
    private func modal(_ controller: UIViewController, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        controller.__segueCoordinator = self
        controller.addCancelButton(self.closeModal)
        let modalNavController = UINavigationController(rootViewController: controller)
        modalNavController.modalPresentationStyle = style
        //Порядок важен. Это позволит добраться до NavigationController в prepareController()
        prepareController(controller)
        getCurrentNavigationController().present(modalNavController, animated: true, completion: nil)
    }
    
    private func modalOrPush(_ controller: UIViewController, clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        if isPhone {
            push(controller, clearStack: clearStack, prepareController: prepareController)
        } else {
            modal(controller, style: style, prepareController: prepareController)
        }
    }
    
    public func popoverOrPush(_ controllerId: String, anchor: UIBarButtonItem? = nil, prepareController: @escaping (UIViewController) -> Void) {
        modalOrPush(controllerId, style: .popover) {
            [weak anchor, unowned self] controller in
            controller.__segueCoordinator = self
            controller.navigationController?.popoverPresentationController?.barButtonItem = anchor
            if !self.isPhone {
                controller.addCloseButton(self.closeModal)
            }
            prepareController(controller)
        }
    }
    
    public func segue(_ segueId: String, prepareController: @escaping (UIViewController) -> Void) {
        controllerPreparationCallbacks[segueId] = prepareController
        
        do {
            try NSExceptionCatch.catchException {[weak self] in
        self?.getCurrentController().performSegue(withIdentifier: segueId, sender: self)
            }
        }
        catch _ {
            print("Невозможно выполнить segue \(segueId) у контроллера \(getCurrentController())")
        }
    }
    
    //Закрытие
    @objc func closeModal() {
        closeModal() {
            
        }
    }
    
    public func closeModal(_ completion: @escaping (()->Void)) {
        getCurrentController().dismiss(animated: true, completion: completion)
    }
    
    public func pop() {
        getCurrentNavigationController().popViewController(animated: true)
    }
    
    public func popToRoot() {
        if let id = rootViewControllerId {
            popTo(id)
        } else {
            popToRoot(allowRecursion: true)
        }
    }
    
    public func popToRoot(allowRecursion: Bool) {
        if allowRecursion {
            getRootNavigationControllerRecursively().popToRootViewController(animated: true)
        } else {
            getCurrentNavigationController().popToRootViewController(animated: true)
        }
    }
    
    public func popTo(_ restorationId: String) {
        for controller in getCurrentNavigationController().viewControllers {
            if controller.restorationIdentifier == restorationId {
                getCurrentNavigationController().popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    public func closeModalOrPop() {
        closeModalOrPop() {
            
        }
    }
    
    public func closeModalOrPop(_ completion: @escaping (()->Void)) {
        if !isPhone {
            closeModal(completion)
        } else {
            pop()
            completion()
        }
    }
    
    public func closeModalOrPopToRoot() {
        closeModalOrPopToRoot() {
            
        }
    }
    
    public func closeModalOrPopToRoot(_ completion: @escaping (()->Void)) {
        if !isPhone {
            closeModal(completion)
        } else {
            popToRoot()
            completion()
        }
    }
    
    public func closeModalOrPopTo(_ restorationId: String) {
        closeModalOrPopTo(restorationId) {
            
        }
    }
    
    public func closeModalOrPopTo(_ restorationId: String, completion: @escaping (()->Void)) {
        if !isPhone {
            closeModal(completion)
        } else {
            popTo(restorationId)
            completion()
        }
    }
    
    //MARK: Реализация
    
    func prepareForSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        for (segueId, callback) in controllerPreparationCallbacks {
            if segue.identifier == segueId {
                let nextController: UIViewController
                if let targetNavigationController = segue.destination as? UINavigationController {
                    nextController = targetNavigationController.viewControllers[0]
                } else {
                    nextController = segue.destination
                }
                nextController.__segueCoordinator = self
                callback(nextController)
                controllerPreparationCallbacks.removeValue(forKey: segueId)
            }
        }
    }
    
    //MARK: Вспомогательные методы
    
    public func getCurrentController() -> UIViewController {
        return getCurrentNavigationController().visibleViewController!
    }
    
    public func getCurrentNavigationController() -> UINavigationController {
        let controller = rootNavigationController.presentedViewController?.presentedViewController?.presentedViewController as? UINavigationController
            ?? rootNavigationController.presentedViewController?.presentedViewController as? UINavigationController
            ?? rootNavigationController.presentedViewController as? UINavigationController
            ?? rootNavigationController
        return controller
    }
    
    public func getRootNavigationControllerRecursively() -> UINavigationController {
        var rootController = getCurrentNavigationController()
        //todo проверить
        while let parent = rootController.navigationController {
            rootController = parent
        }
        return rootController
    }
    
    var isPhone: Bool {
        return UI_USER_INTERFACE_IDIOM() == .phone
    }
}
