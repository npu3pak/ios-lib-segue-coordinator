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
        segue("ShowFirst") {
            let controller = $0 as! FirstViewController
            controller.title = "First"
            controller.onShowSecond = self.showSecondFromFirst
        }
    }
    
    func showSecondFromFirst() {
        segue("ShowSecond") {
            let controller = $0 as! SecondViewController
            controller.title = "Second"
        }
    }
    
    func showSecond() {
        push("Second") {
            let controller = $0 as! SecondViewController
            controller.title = "Second"
        }
    }
    
    func showThird() {
        modal("Third") {
            let controller = $0 as! ThirdViewController
            controller.title = "Third"
        }
    }
}
