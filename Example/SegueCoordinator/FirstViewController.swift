//
//  FirstViewController.swift
//  SegueCoordinator
//
//  Created by Евгений Сафронов on 26.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SegueCoordinator

class FirstViewController: UIViewController {
    var onShowSecond: (() -> Void)?
    
    @IBAction func onShowSecondButtonClick(_ sender: Any) {
        onShowSecond?()
    }
}

