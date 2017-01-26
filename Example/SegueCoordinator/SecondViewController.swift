//
//  SecondViewController.swift
//  SegueCoordinator
//
//  Created by Евгений Сафронов on 26.01.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SegueCoordinator

class SecondViewController: UIViewController {
    var coordinator: SegueCoordinator?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        coordinator?.prepareForSegue(segue, sender: sender)
    }
}

