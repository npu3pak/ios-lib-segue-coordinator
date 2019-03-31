//
//  ThirdViewController.swift
//  SegueCoordinator
//
//  Created by Евгений Сафронов on 26.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SegueCoordinator

class ThirdViewController: UIViewController {

    var onCancel: (() -> Void)?
    var onShowFourthWithPush: (() -> Void)?
    var onShowFourthWithSegue: (() -> Void)?

    @IBAction func onCancelButtonClick(_ sender: Any) {
        onCancel?()
    }

    @IBAction func onShowFourthButtonWithPushClick(_ sender: Any) {
        onShowFourthWithPush?()
    }

    @IBAction func onShowFourthButtonWithSegueClick(_ sender: Any) {
        onShowFourthWithSegue?()
    }
}
