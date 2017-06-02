//
//  UIViewControllerExrensions.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//
//

import Foundation
private var closureTargets = [ClosureWrapper]()

extension UIViewController {
    public func addCancelButton(_ action: @escaping () -> Void) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, closure: action)
    }
    
    public func addCloseButton(_ action: @escaping () -> Void) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, closure: action)
    }
}

extension UIBarButtonItem {
    convenience init(image: UIImage?, style: UIBarButtonItemStyle, closure: @escaping () -> ()) {
        closureTargets.append(ClosureWrapper(closure))
        self.init(image: image, style: style, target: closureTargets.last!, action: #selector(ClosureWrapper.invoke))
    }
    
    convenience init(title: String?, style: UIBarButtonItemStyle, closure: @escaping () -> ()) {
        closureTargets.append(ClosureWrapper(closure))
        self.init(title: title, style: style, target: closureTargets.last!, action: #selector(ClosureWrapper.invoke))
    }
    
    convenience init(systemItem: UIBarButtonSystemItem, closure: @escaping () -> ()) {
        closureTargets.append(ClosureWrapper(closure))
        self.init(barButtonSystemItem: systemItem, target: closureTargets.last!, action: #selector(ClosureWrapper.invoke))
    }
}

private class ClosureWrapper {
    private var closure: () -> ()
    
    init(_ closure:@escaping () -> ()) {
        self.closure = closure
    }
    
    @objc @IBAction func invoke() {
        closure()
    }
}
