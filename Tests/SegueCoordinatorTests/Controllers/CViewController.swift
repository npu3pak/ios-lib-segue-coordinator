//
//  CViewController.swift
//  SegueCoordinatorTests
//
//  Created by Евгений Сафронов on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class CViewController: UIViewController, PTestableController {

    var onDidAppear: (() -> Void)?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onDidAppear?()
    }
}
