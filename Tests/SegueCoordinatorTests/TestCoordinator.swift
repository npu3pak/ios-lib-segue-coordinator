//
//  TestCoordinator.swift
//  SegueCoordinatorTests
//
//  Created by Евгений Сафронов on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import SegueCoordinator

class TestCoordinator: SegueCoordinator {
    init(rootNavigationController: UINavigationController) {
        super.init(storyboardName: "Test", rootNavigationController: rootNavigationController)
    }
}
