//
//  FourthViewController.swift
//  SegueCoordinator_Example
//
//  Created by Евгений Сафронов on 31/03/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    var onUnwindToRoot: (()->Void)?
    var onUnwindToThird: (()->Void)?
    var onUnwindToFourth: (()->Void)?
    var onUnwindToFirstNavigation: (()->Void)?

    @IBAction private func onUnwindToRootButtonClick(_ sender: Any) {
        onUnwindToRoot?()
    }

    @IBAction private func onUnwindToThirdButtonClick(_ sender: Any) {
        onUnwindToThird?()
    }

    @IBAction private func onUnwindToFourthButtonClick(_ sender: Any) {
        onUnwindToFourth?()
    }

    @IBAction private func onUnwindToFirstNavigationButtonClick(_ sender: Any) {
        onUnwindToFirstNavigation?()
    }
}
