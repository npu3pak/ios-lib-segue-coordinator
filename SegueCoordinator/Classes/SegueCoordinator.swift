//
//  SegueCoordinator.swift
//  Pods
//
//  Created by Евгений Сафронов on 25.01.17.
//

import UIKit

open class SegueCoordinator {

    public let storyboard: UIStoryboard
    public let rootNavigationController: UINavigationController

    var seguePreparationActions = [String: (UIViewController) -> Void]()

    /**
     Typically, you should override this initializer and specify storyboard name.

     ### Example: ###
     ````
     init(navController: UINavigationController) {
        super.init(storyboardName: "Main", rootNavigationController: navController)
     }
     ````

     - Parameter storyboardName: Name of the storyboard the coordinator will work with.
     - Parameter rootNavigationController: Navigation controller for displaying controllers created by coordinator.
     */

    public init(storyboardName: String, rootNavigationController: UINavigationController) {
        UIViewController.swizzlePrepareForSegue()

        self.rootNavigationController = rootNavigationController

        let bundle = Bundle(for: type(of: self))
        storyboard = UIStoryboard.init(name: storyboardName, bundle: bundle)
    }
}
