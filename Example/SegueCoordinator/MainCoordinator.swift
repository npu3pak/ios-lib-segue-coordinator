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

    init(rootNavigationController: UINavigationController) {
        super.init(storyboardName: "Main", rootNavigationController: rootNavigationController)
    }

    func start() {
        // Fill empty rootNavigationController with initial view controller
        setInitial(type: RootViewController.self) {
            $0.showFirst = showFirst
            $0.showSecond = showSecond
            $0.showThird = showThird
        }
    }
    
    func showFirst() {
        // Perform segue with identifier "ShowFirst"
        segue("ShowFirst", type: FirstViewController.self) {
            // Initialize controller. This it prepareForSegue replacement
            $0.title = "First"
            // It's unnecessary to make weak/unowned capturing here, but be careful.
            $0.onShowSecond = self.showSecondFromFirst
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
            // We can add close button here
            $0.addLeftBarButton("Close") { [unowned self] in self.closeModal() }
            $0.title = "Third"
        }
    }
}
