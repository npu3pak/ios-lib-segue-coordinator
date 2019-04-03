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

    func testPushAndModal() {
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
        modalSync("A", type: AViewController.self, wrap: false)
        XCTAssert(coordinator.topController is AViewController)

        modalSync("B", type: BViewController.self, wrap: false)
        XCTAssert(coordinator.topController is BViewController)

        modalSync("C", type: CViewController.self)
        XCTAssert(coordinator.topController is CViewController)

        modalSync("D", type: DViewController.self, wrap: false)
        XCTAssert(coordinator.topController is DViewController)

        // Push on unwrapped top view controller should do nothing
        let e = expectation(description: "Transition should not happen")
        e.isInverted = true
        coordinator.push("E", type: EViewController.self, prepareController: { $0.onDidAppear = e.fulfill })
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(coordinator.topController is DViewController)
    }

    func testPop() {
        buildStack("pA pB mC pD mE mF pG")

        // pA pB mC pD mE mF pG
        XCTAssert(coordinator.topController is GViewController)

        coordinator.pop()
        // pA pB mC pD mE mF
        XCTAssert(coordinator.topController is FViewController)

        coordinator.pop()
        // pA pB mC pD mE mF
        XCTAssert(coordinator.topController is FViewController)

        closeModalSync()
        // pA pB mC pD mE
        XCTAssert(coordinator.topController is EViewController)

        closeModalSync()
        // pA pB mC pD
        XCTAssert(coordinator.topController is DViewController)

        coordinator.pop()
        // pA pB mC
        XCTAssert(coordinator.topController is CViewController)

        closeModalSync()
        // pA pB
        XCTAssert(coordinator.topController is BViewController)

        coordinator.pop()
        // pA
        XCTAssert(coordinator.topController is AViewController)

        coordinator.pop()
        // pA
        XCTAssert(coordinator.topController is AViewController)
    }

    func testCloseModal() {
        buildStack("pA mB pC uD mE uF uG")

        // pA mB pC uD mE uF uG
        XCTAssert(coordinator.topController is GViewController)

        closeModalSync()
        // pA mB pC uD mE uF
        XCTAssert(coordinator.topController is FViewController)

        closeModalSync()
        // pA mB pC uD mE
        XCTAssert(coordinator.topController is EViewController)

        closeModalSync()
        // pA mB pC uD
        XCTAssert(coordinator.topController is DViewController)

        closeModalSync()
        // pA mB pC
        XCTAssert(coordinator.topController is CViewController)

        closeModalSync()
        // pA
        XCTAssert(coordinator.topController is AViewController)

        closeModalSync()
        // pA
        XCTAssert(coordinator.topController is AViewController)
    }

    // MARK: - Synchronous transition methods

    /*
     m - wrapped modal
     u - unwrapped modal
     p - push
    */
    private func buildStack(_ stack: String) {
        let commands: [(action: String, id: String)] = stack.split(separator: " ").map {
            let item = NSString(string: String($0))
            return (action: item.substring(to: 1), id: item.substring(from: 1))
        }
        for (action, id) in commands {
            switch action {
            case "m": modalSync(id, type: TestableController.self)
            case "u": modalSync(id, type: TestableController.self, wrap: false)
            case "p": pushSync(id, type: TestableController.self)
            default: break
            }
        }
    }

    private func pushInitialSync<T: TestableController>(type: T.Type) {
        let e = XCTestExpectation(description: "Waiting for appear")
        coordinator.pushInitial(type: type, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func pushSync<T: TestableController>(_ storyboardId: String, type: T.Type) {
        let e = XCTestExpectation(description: "Waiting \(storyboardId) for appear")
        coordinator.push(storyboardId, type: type, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func modalInitialSync<T: TestableController>(type: T.Type, wrap: Bool = true) {
        let e = XCTestExpectation(description: "Waiting for appear")
        coordinator.modalInitial(type: type, style: .formSheet, wrapInNavigationController: wrap, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func modalSync<T: TestableController>(_ storyboardId: String, type: T.Type, wrap: Bool = true) {
        let e = XCTestExpectation(description: "Waiting \(storyboardId) for appear")
        coordinator.modal(storyboardId, type: type, style: .formSheet, wrapInNavigationController: wrap, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func closeModalSync() {
        let e = XCTestExpectation(description: "Waiting for closing modal")
        coordinator.closeModal(animated: true, completion: e.fulfill )
        wait(for: [e], timeout: 1)
    }
}
