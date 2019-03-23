//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//

import UIKit
import ObjectiveC

open class SegueCoordinator {

    public let storyboard: UIStoryboard
    public let rootNavigationController: UINavigationController

    private var seguePreparationActions = [String: (UIViewController) -> Void]()

    public init(storyboardName: String, rootNavigationController: UINavigationController) {
        UIViewController.swizzlePrepareForSegue()

        self.rootNavigationController = rootNavigationController

        let bundle = Bundle(for: type(of: self))
        storyboard = UIStoryboard.init(name: storyboardName, bundle: bundle)
    }

    public init(rootViewController: UIViewController) {
        UIViewController.swizzlePrepareForSegue()
        rootNavigationController = rootViewController.navigationController!
        storyboard = rootViewController.storyboard!
    }

    // MARK: - Segues

    public func segue<T: UIViewController>(_ segueId: String, type: T.Type, prepareController: @escaping (T) -> Void) {
        segue(segueId) {
            prepareController($0 as! T)
        }
    }

    private func segue(_ segueId: String, prepareController: @escaping (UIViewController) -> Void) {
        seguePreparationActions[segueId] = prepareController

        do {
            try NSExceptionCatch.catchException {
                self.currentController.pendingSegueCoordinator = self
                self.currentController.performSegue(withIdentifier: segueId, sender: self)
            }
        } catch _ {
            self.currentController.pendingSegueCoordinator = nil
            print("Невозможно выполнить segue \(segueId) у контроллера \(currentController)")
        }
    }

    fileprivate func prepareForSegue(_ segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, let action = seguePreparationActions[segueId] else {
            return
        }

        currentController.pendingSegueCoordinator = nil

        let nextController: UIViewController
        if let targetNavigationController = segue.destination as? UINavigationController {
            nextController = targetNavigationController.viewControllers[0]
        } else {
            nextController = segue.destination
        }

        action(nextController)
        seguePreparationActions.removeValue(forKey: segueId)
    }

    // MARK: - Создание

    public func instantiateInitial<T: UIViewController>(type: T.Type) -> T {
        return storyboard.instantiateInitialViewController() as! T
    }

    public func instantiate<T: UIViewController>(_ storyboardId: String, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }

    // MARK: - Переходы

    public func pushInitial<T: UIViewController>(type: T.Type, clearStack: Bool = false, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }

    public func modalInitial<T: UIViewController>(type: T.Type, style: UIModalPresentationStyle = .formSheet, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateInitialViewController() as! T
        modal(controller, style: style, prepareController: prepareController)
    }

    public func push<T: UIViewController>(_ controllerId: String, type: T.Type, clearStack: Bool = false, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        push(controller, clearStack: clearStack, prepareController: prepareController)
    }

    public func replaceTop<T: UIViewController>(_ controllerId: String, type: T.Type, animated: Bool, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        replaceTop(controller, animated: animated, prepareController: prepareController)
    }

    public func modal<T: UIViewController>(_ controllerId: String, type: T.Type, style: UIModalPresentationStyle, prepareController: (T) -> Void) {
        let controller = storyboard.instantiateViewController(withIdentifier: controllerId) as! T
        modal(controller, style: style, prepareController: prepareController)
    }

    private func push<T: UIViewController>(_ controller: T, clearStack: Bool = false, prepareController: (T) -> Void) {
        prepareController(controller)
        if clearStack {
            rootNavigationController.viewControllers = [controller]
        } else {
            rootNavigationController.pushViewController(controller, animated: true)
        }
    }

    private func replaceTop<T: UIViewController>(_ controller: T, animated: Bool, prepareController: (T) -> Void) {
        prepareController(controller)
        var controllers = rootNavigationController.viewControllers
        controllers.removeLast()
        controllers.append(controller)
        rootNavigationController.setViewControllers(controllers, animated: animated)
    }

    private func modal<T: UIViewController>(_ controller: T, style: UIModalPresentationStyle, prepareController: (T) -> Void) {
        let modalNavController = UINavigationController(rootViewController: controller)
        modalNavController.modalPresentationStyle = style
        //Порядок важен. Это позволит добраться до NavigationController в prepareController()
        prepareController(controller)
        rootNavigationController.present(modalNavController, animated: true, completion: nil)
    }

    public func closeModal(_ completion: @escaping (() -> Void) = {}) {
        currentController.dismiss(animated: true, completion: completion)
    }

    public func pop() {
        rootNavigationController.popViewController(animated: true)
    }

    public func popTo(_ restorationId: String) {
        if let controller = rootNavigationController.viewControllers.first(where: { $0.restorationIdentifier == restorationId }) {
            rootNavigationController.popToViewController(controller, animated: true)
        }
    }

    // MARK: - Вспомогательные методы

    public var currentController: UIViewController {
        return rootNavigationController.viewControllers.last!
    }
}

// MARK: - Свиззлинг prepareForSegue

// Хэндлер для ссылки на segueCoordinator
private var segueCoordinatorPropertyHandle: UInt8 = 0

// Подменяем prepareForSegue.
// Поскольку dispatch_once убрали, приходится использовать глобальную константу, чтобы убедиться что код выполнится один раз.
private let swizzling: () = {
    let originalSelector = #selector(UIViewController.prepare(for:sender:))
    let swizzledSelector = #selector(UIViewController.swizzled_prepare(for:sender:))

    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)

    method_exchangeImplementations(originalMethod!, swizzledMethod!)
}()

fileprivate extension UIViewController {
    //Выполняем подмену
    static func swizzlePrepareForSegue() {
        _ = swizzling
    }

    //Добавляем новое свойство - слабую ссылку на SegueCoordinator
    weak var pendingSegueCoordinator: SegueCoordinator? {
        get {
            return objc_getAssociatedObject(self, &segueCoordinatorPropertyHandle) as? SegueCoordinator
        }
        set {
            objc_setAssociatedObject(self, &segueCoordinatorPropertyHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    //Пробрасываем prepareForSegue в координатор
    @objc func swizzled_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.swizzled_prepare(for: segue, sender: sender)
        pendingSegueCoordinator?.prepareForSegue(segue, sender: sender)
    }
}
