//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//
//

import Foundation

class SegueCoordinator {
    let storyboard: UIStoryboard
    let rootNavigationController: UINavigationController
    let rootViewControllerId: String?
    var controllerPreparationCallbacks: Dictionary<String, ((UIViewController) -> Void)> = [:]
    
    init(storyboardName: String, rootNavigationController: UINavigationController, rootViewControllerId: String? = nil) {
        self.rootNavigationController = rootNavigationController
        self.rootViewControllerId = rootViewControllerId
        storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
    }
    
    //MARK: API
    
    func pushInitial(clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }
    
    func modalInitial(_ style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        modal(controller, style: style, prepareController: prepareController)
    }
    
    func modalOrPushInitial(clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateInitialViewController()!
        modalOrPush(controller, clearStack: clearStack, style: style, prepareController: prepareController)
    }
    
    func push(_ controllerId: String, clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId)
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }
    
    func modal(_ controllerId: String, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId)
        modal(controller, style: style, prepareController: prepareController)
    }
    
    func modalOrPush(_ controllerId: String, clearStack: Bool = false, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
        if isPhone {
            push(controllerId, clearStack: clearStack, prepareController: prepareController)
        } else {
            modal(controllerId, style: style, prepareController: prepareController)
        }
    }
    
    private func push(_ controller: UIViewController, clearStack: Bool = false, prepareController: (UIViewController) -> Void) {
        prepareController(controller)
        if clearStack {
            getCurrentNavigationController().viewControllers = [controller]
        } else {
            getCurrentNavigationController().pushViewController(controller, animated: true)
        }
    }
    
    private func modal(_ controller: UIViewController, style: UIModalPresentationStyle = .formSheet, prepareController: (UIViewController) -> Void) {
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
    
    func popoverOrPush(_ controllerId: String, anchor: UIBarButtonItem? = nil, prepareController: @escaping (UIViewController) -> Void) {
        modalOrPush(controllerId, style: .popover) {
            [weak anchor, unowned self] controller in
            controller.navigationController?.popoverPresentationController?.barButtonItem = anchor
            if !self.isPhone {
                controller.addCloseButton(self.closeModal)
            }
            prepareController(controller)
        }
    }
    
    func segue(_ segueId: String, prepareController: @escaping (UIViewController) -> Void) {
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
    
    func closeModal(_ completion: @escaping (()->Void)) {
        getCurrentController().dismiss(animated: true, completion: completion)
    }
    
    func pop() {
        getCurrentNavigationController().popViewController(animated: true)
    }
    
    func popToRoot() {
        if let id = rootViewControllerId {
            popTo(id)
        } else {
            popToRoot(allowRecursion: true)
        }
    }
    
    func popToRoot(allowRecursion: Bool) {
        if allowRecursion {
            getRootNavigationControllerRecursively().popToRootViewController(animated: true)
        } else {
            getCurrentNavigationController().popToRootViewController(animated: true)
        }
    }
    
    func popTo(_ restorationId: String) {
        for controller in getCurrentNavigationController().viewControllers {
            if controller.restorationIdentifier == restorationId {
                getCurrentNavigationController().popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func closeModalOrPop() {
        closeModalOrPop() {
            
        }
    }
    
    func closeModalOrPop(_ completion: @escaping (()->Void)) {
        if !isPhone {
            closeModal(completion)
        } else {
            pop()
            completion()
        }
    }
    
    func closeModalOrPopToRoot() {
        closeModalOrPopToRoot() {
            
        }
    }
    
    func closeModalOrPopToRoot(_ completion: @escaping (()->Void)) {
        if !isPhone {
            closeModal(completion)
        } else {
            popToRoot()
            completion()
        }
    }
    
    func closeModalOrPopTo(_ restorationId: String) {
        closeModalOrPopTo(restorationId) {
            
        }
    }
    
    func closeModalOrPopTo(_ restorationId: String, completion: @escaping (()->Void)) {
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
                callback(nextController)
                controllerPreparationCallbacks.removeValue(forKey: segueId)
            }
        }
    }
    
    //MARK: Вспомогательные методы
    
    func getCurrentController() -> UIViewController {
        return getCurrentNavigationController().visibleViewController!
    }
    
    func getCurrentNavigationController() -> UINavigationController {
        let controller = rootNavigationController.presentedViewController?.presentedViewController?.presentedViewController
            ?? rootNavigationController.presentedViewController?.presentedViewController
            ?? rootNavigationController.presentedViewController
            ?? rootNavigationController
        return controller as! UINavigationController
    }
    
    func getRootNavigationControllerRecursively() -> UINavigationController {
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
