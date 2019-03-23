//
//  RootViewController.swift
//  SegueCoordinator
//
//  Created by Евгений Сафронов on 26.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SegueCoordinator

class RootViewController: UIViewController {
    
    var showFirst: (() -> Void)?
    var showSecond: (() -> Void)?
    var showThird: (() -> Void)?
    
    @IBAction func onShowFirst(_ sender: Any) {
        showFirst?()
    }
    
    @IBAction func onShowSecond(_ sender: Any) {
        showSecond?()
    }
    
    @IBAction func onShowThird(_ sender: Any) {
        showThird?()
    }
}
