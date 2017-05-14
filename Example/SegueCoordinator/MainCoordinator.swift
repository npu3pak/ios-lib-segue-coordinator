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
        segue("ShowFirst", type: FirstViewController.self) {
            $0.title = "First"
            $0.onShowSecond = self.showSecondFromFirst
        }
    }
    
    func showSecondFromFirst() {
        segue("ShowSecond", type: SecondViewController.self) {
            $0.title = "Second"
        }
    }
    
    func showSecond() {
        push("Second", type: SecondViewController.self) {
            $0.title = "Second"
        }
    }
    
    func showThird() {
        modal("Third", type: ThirdViewController.self) {
            $0.title = "Third"
        }
    }
}
