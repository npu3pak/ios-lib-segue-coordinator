//
//  SegueCoordinatorTests.swift
//  SegueCoordinatorTests
//
//  Created by Евгений Сафронов on 02/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import SegueCoordinator

class SegueCoordinatorTests: XCTestCase {

    var coordinator: TestCoordinator!

    override func setUp() {
        let navigationController = UINavigationController()
        let window = UIApplication.shared.delegate!.window!
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        coordinator = TestCoordinator(rootNavigationController: navigationController)
    }

    // MARK: - Set

    func testSetInitial() {
        XCTAssert(coordinator.topController is UINavigationController)

        let e = expectation(description: "Waiting for appear")
        coordinator.setInitial(type: InitialViewController.self, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is InitialViewController)
    }

    func testSet() {
        XCTAssert(coordinator.topController is UINavigationController)

        let e = expectation(description: "Waiting for appear")
        coordinator.set("A", type: AViewController.self, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is AViewController)
    }

    func testSetWithStackReplace() {
        XCTAssert(coordinator.topController is UINavigationController)

        coordinator.setInitial(type: InitialViewController.self, prepareController: { _ in })
        XCTAssert(coordinator.topController is InitialViewController)

        coordinator.set("A", type: AViewController.self, prepareController: { _ in })
        XCTAssert(coordinator.topController is AViewController)
    }

    // MARK: - Instantiate
    
    func  testInstantiateInitial() {
        _ = coordinator.instantiateInitial(type: InitialViewController.self)
    }

    func  testInstantiate() {
        _ = coordinator.instantiate("A", type: AViewController.self)
    }

    // MARK: - Push

    func testPushInitial() {
        let e = expectation(description: "Waiting for appear")
        coordinator.pushInitial(type: InitialViewController.self, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is InitialViewController)
    }

    func testPush() {
        let e = expectation(description: "Waiting for appear")
        coordinator.push("A", type: AViewController.self, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is AViewController)
    }

    func testPushController() {
        let aViewController = coordinator.instantiate("A", type: AViewController.self)

        let e = expectation(description: "Waiting for appear")
        coordinator.pushController(aViewController, prepareController: { $0.onDidAppear = e.fulfill } )
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is AViewController)
    }

    func testPushAfterPush() {
        let waitA = expectation(description: "Waiting for A")
        coordinator.push("A", type: AViewController.self, prepareController: { $0.onDidAppear = waitA.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(coordinator.topController is AViewController)

        let waitB = expectation(description: "Waiting for B")
        coordinator.push("B", type: BViewController.self, prepareController: { $0.onDidAppear = waitB.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(coordinator.topController is BViewController)

        let waitC = expectation(description: "Waiting for C")
        coordinator.push("C", type: CViewController.self, prepareController: { $0.onDidAppear = waitC.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(coordinator.topController is CViewController)
    }
}
