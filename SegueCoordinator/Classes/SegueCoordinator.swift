//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//
//

import Foundation

open class SegueCoordinator {
    let storyboard: UIStoryboard
    let rootNavigationController: UINavigationController
    let rootViewControllerId: String?
    var controllerPreparationCallbacks: Dictionary<String, ((UIViewController) -> Void)> = [:]
    
    public init(storyboardName: String, rootNavigationController: UINavigationController, rootViewControllerId: String? = nil) {
        UIViewController.swizzlePrepareForSegue()
        
        self.rootNavigationController = rootNavigationController
        self.rootViewControllerId = rootViewControllerId
        storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
    }
    
    public init(rootViewController: UIViewController) {
        UIViewController.swizzlePrepareForSegue()
        
        storyboard = rootViewController.storyboard!
        rootNavigationController = rootViewController.navigationController!
        rootViewControllerId = rootViewController.restorationIdentifier
        
        rootViewController.__segueCoordinator = self
    }
    
    //MARK: API
    
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
        let controller = rootNavigationController.presentedViewController?.presentedViewController?.presentedViewController
            ?? rootNavigationController.presentedViewController?.presentedViewController
            ?? rootNavigationController.presentedViewController
            ?? rootNavigationController
        return controller as! UINavigationController
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
