//
//  ViewControllerExtension.swift
//  Pods
//
//  Created by Evgeniy Safronov on 10.05.17.
//
//

import UIKit
import ObjectiveC

// Хэндлер для ссылки на segueCoordinator
fileprivate var segueCoordinatorPropertyHandle: UInt8 = 0

// Подменяем prepareForSegue.
// Поскольку dispatch_once убрали, приходится использовать глобальную константу, чтобы убедиться что код выполнится один раз.
fileprivate let swizzling: () = {
    let originalSelector = #selector(UIViewController.prepare(for:sender:))
    let swizzledSelector = #selector(UIViewController.swizzled_prepare(for:sender:))
    
    let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector)
    let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector)
    
    method_exchangeImplementations(originalMethod, swizzledMethod)
}()

extension UIViewController {
    //Выполняем подмену
    static func swizzlePrepareForSegue() {
        _ = swizzling
    }
    
    //Добавляем новое свойство - слабую ссылку на SegueCoordinator
    weak var __segueCoordinator: SegueCoordinator? {
        get {
            return objc_getAssociatedObject(self, &segueCoordinatorPropertyHandle) as? SegueCoordinator
        }
        set {
            objc_setAssociatedObject(self, &segueCoordinatorPropertyHandle, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //Пробрасываем prepareForSegue в координатор
    func swizzled_prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.swizzled_prepare(for: segue, sender: sender)
        __segueCoordinator?.prepareForSegue(segue, sender: sender)
    }
}
