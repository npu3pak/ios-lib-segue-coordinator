//
//  PTestableController.swift
//  SegueCoordinatorExample
//
//  Created by Евгений Сафронов on 03/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol PTestableController: UIViewController {
    var onDidAppear: (() -> Void)? { set get }
}
