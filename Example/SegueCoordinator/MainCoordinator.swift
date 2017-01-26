//
//  MainCoordinator.swift
//  SegueCoordinator
//
//  Created by Евгений Сафронов on 26.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SegueCoordinator

class MainCoordinator: SegueCoordinator {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        let root = rootViewController as! RootViewController
        root.showFirst = showFirst
        root.showSecond = showSecond
        root.showThird = showThird
    }
    
    func showFirst() {
        segue("ShowFirst") { [weak self] controller in
            let firstController = controller as! FirstViewController
            firstController.coordinator = self
        }
    }
    
    func showSecond() {
        push("Second") { [weak self] controller in
            let secondController = controller as! SecondViewController
            secondController.coordinator = self
        }
    }
    
    func showThird() {
        modal("Third") { [weak self] controller in
            let thirdController = controller as! ThirdViewController
            thirdController.coordinator = self
        }
    }
}
