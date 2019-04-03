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
        pushInitialSync(type: InitialViewController.self)
        XCTAssert(coordinator.topController is InitialViewController)
    }

    func testPush() {
        pushSync("A", type: AViewController.self)
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
        pushSync("A", type: AViewController.self)
        XCTAssert(coordinator.topController is AViewController)

        pushSync("B", type: BViewController.self)
        XCTAssert(coordinator.topController is BViewController)

        pushSync("C", type: CViewController.self)
        XCTAssert(coordinator.topController is CViewController)
    }

    // MARK: - Modal

    func testModalInitial() {
        modalInitialSync(type: InitialViewController.self)
        XCTAssert(coordinator.topController is InitialViewController)
    }

    func testModal() {
        modalSync("A", type: AViewController.self)
        XCTAssert(coordinator.topController is AViewController)
    }

    func testModalController() {
        let aViewController = coordinator.instantiate("A", type: AViewController.self)

        let e = expectation(description: "Waiting for appear")
        coordinator.modalController(aViewController, style: .formSheet, prepareController: { $0.onDidAppear = e.fulfill } )
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssert(coordinator.topController is AViewController)
    }

    func testPushAndModal1() {
        // mA pB mC pD mE pF mG

        modalSync("A", type: AViewController.self)
        XCTAssert(coordinator.topController is AViewController)

        pushSync("B", type: BViewController.self)
        XCTAssert(coordinator.topController is BViewController)

        modalSync("C", type: CViewController.self)
        XCTAssert(coordinator.topController is CViewController)

        pushSync("D", type: DViewController.self)
        XCTAssert(coordinator.topController is DViewController)

        modalSync("E", type: EViewController.self)
        XCTAssert(coordinator.topController is EViewController)

        pushSync("F", type: FViewController.self)
        XCTAssert(coordinator.topController is FViewController)

        modalSync("G", type: GViewController.self)
        XCTAssert(coordinator.topController is GViewController)
    }

    func testPushAndModal2() {
        // mA mB pC pD mE mF pG

        modalSync("A", type: AViewController.self)
        XCTAssert(coordinator.topController is AViewController)

        modalSync("B", type: BViewController.self)
        XCTAssert(coordinator.topController is BViewController)

        pushSync("C", type: CViewController.self)
        XCTAssert(coordinator.topController is CViewController)

        pushSync("D", type: DViewController.self)
        XCTAssert(coordinator.topController is DViewController)

        modalSync("E", type: EViewController.self)
        XCTAssert(coordinator.topController is EViewController)

        modalSync("F", type: FViewController.self)
        XCTAssert(coordinator.topController is FViewController)

        pushSync("G", type: GViewController.self)
        XCTAssert(coordinator.topController is GViewController)
    }

    func testUnwrappedModal() {
        
    }

    // MARK: - Synchronous transition methods

    private func pushInitialSync<T: PTestableController>(type: T.Type) {
        let e = expectation(description: "Waiting for appear")
        coordinator.pushInitial(type: type, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
    }

    private func pushSync<T: PTestableController>(_ storyboardId: String, type: T.Type) {
        let e = expectation(description: "Waiting \(storyboardId) for appear")
        coordinator.push(storyboardId, type: type, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
    }

    private func modalInitialSync<T: PTestableController>(type: T.Type, wrap: Bool = true) {
        let e = expectation(description: "Waiting for appear")
        coordinator.modalInitial(type: type, style: .formSheet, wrapInNavigationController: wrap, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
    }

    private func modalSync<T: PTestableController>(_ storyboardId: String, type: T.Type, wrap: Bool = true) {
        let e = expectation(description: "Waiting \(storyboardId) for appear")
        coordinator.modal(storyboardId, type: type, style: .formSheet, wrapInNavigationController: wrap, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
    }
}
