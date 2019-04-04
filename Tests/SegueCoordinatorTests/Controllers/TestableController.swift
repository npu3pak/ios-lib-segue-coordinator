//
//  PTestableController.swift
//  SegueCoordinatorExample
//
//  Created by Евгений Сафронов on 03/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class TestableController: UIViewController {
    
    var onDidAppear: (() -> Void)?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onDidAppear?()
    }
}
