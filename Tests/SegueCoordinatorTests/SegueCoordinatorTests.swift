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
        checkStack("pA pB mC pD mE mF pG")

        coordinator.pop()
        checkStack("pA pB mC pD mE mF")

        coordinator.pop()
        checkStack("pA pB mC pD mE mF")

        closeModalSync()
        checkStack("pA pB mC pD mE")

        closeModalSync()
        checkStack("pA pB mC pD")

        coordinator.pop()
        checkStack("pA pB mC")

        closeModalSync()
        checkStack("pA pB")

        coordinator.pop()
        checkStack("pA")

        coordinator.pop()
        checkStack("pA")
    }

    func testCloseModal() {
        buildStack("pA mB pC uD mE uF uG")
        checkStack("pA mB pC uD mE uF uG")

        closeModalSync()
        checkStack("pA mB pC uD mE uF")

        closeModalSync()
        checkStack("pA mB pC uD mE")

        closeModalSync()
        checkStack("pA mB pC uD")

        closeModalSync()
        checkStack("pA mB pC")

        closeModalSync()
        checkStack("pA")

        closeModalSync()
        checkStack("pA")
    }

    func testUnwindToFirst() {
        buildStack("pInitial")

        func clearStack() {
            unwindToFirstSync(InitialViewController.self)
            checkStack("pInitial")
        }

        buildStack("pA pB pC pD pE pF pG")
        unwindToFirstSync(AViewController.self)
        checkStack("pInitial pA")
        clearStack()

        buildStack("pA pB pC pD pE pF pG")
        unwindToFirstSync(GViewController.self)
        checkStack("pInitial pA pB pC pD pE pF pG")
        clearStack()

        buildStack("pA pB pC pD pE pF pG")
        unwindToFirstSync(DViewController.self)
        checkStack("pInitial pA pB pC pD")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToFirstSync(AViewController.self)
        checkStack("pInitial mA")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToFirstSync(GViewController.self)
        checkStack("pInitial mA mB mC mD mE mF mG")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToFirstSync(DViewController.self)
        checkStack("pInitial mA mB mC mD")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(AViewController.self)
        checkStack("pInitial pA")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(BViewController.self)
        checkStack("pInitial pA mB")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(CViewController.self)
        checkStack("pInitial pA mB pC")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(DViewController.self)
        checkStack("pInitial pA mB pC uD")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(EViewController.self)
        checkStack("pInitial pA mB pC uD mE")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(FViewController.self)
        checkStack("pInitial pA mB pC uD mE mF")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToFirstSync(GViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG")
        clearStack()
    }

    func testUnwindToLast() {
        buildStack("pInitial")

        func clearStack() {
            unwindToFirstSync(InitialViewController.self)
            checkStack("pInitial")
        }

        buildStack("pA pB pC pD pE pF pG")
        unwindToLastSync(AViewController.self)
        checkStack("pInitial pA")
        clearStack()

        buildStack("pA pB pC pD pE pF pG")
        unwindToLastSync(GViewController.self)
        checkStack("pInitial pA pB pC pD pE pF pG")
        clearStack()

        buildStack("pA pB pC pD pE pF pG")
        unwindToLastSync(DViewController.self)
        checkStack("pInitial pA pB pC pD")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToLastSync(AViewController.self)
        checkStack("pInitial mA")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToLastSync(GViewController.self)
        checkStack("pInitial mA mB mC mD mE mF mG")
        clearStack()

        buildStack("mA mB mC mD mE mF mG")
        unwindToLastSync(DViewController.self)
        checkStack("pInitial mA mB mC mD")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(AViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(BViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF mE uD uC mB")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(CViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF mE uD uC")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(DViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF mE uD")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(EViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF mE")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(FViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG mF")
        clearStack()

        buildStack("pA mB pC uD mE mF pG pG mF mE uD uC mB pA")
        unwindToLastSync(GViewController.self)
        checkStack("pInitial pA mB pC uD mE mF pG pG")
        clearStack()
    }

    // MARK: - Synchronous transition methods

    private func checkStack(_ expected: String) {
        XCTAssertEqual(stackDescription, expected)
    }

    /*
     m - wrapped modal
     u - unwrapped modal
     p - push
    */
    private func buildStack(_ stack: String) {
        let initialStack = stackDescription

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
        var resultStack = stackDescription
        resultStack.removeFirst(initialStack.count)
        resultStack = resultStack.trimmingCharacters(in: .whitespaces)
        XCTAssertEqual(stack, resultStack)
    }

    /*
     m - wrapped modal
     u - unwrapped modal
     p - push
     */
    private var stackDescription: String {
        var commands = [(action: String, id: String)]()

        var root: UIViewController? = coordinator.rootNavigationController
        while root != nil {
            if root!.presentingViewController == nil {
                if let navigationController = root as? UINavigationController {
                    for child in navigationController.viewControllers {
                        commands.append(("p", child.restorationIdentifier!))
                    }
                }
            } else {
                if let navigationController = root as? UINavigationController {
                    commands.append(("m", navigationController.viewControllers.first!.restorationIdentifier!))
                    for child in navigationController.viewControllers.suffix(from: 1) {
                        commands.append(("p", child.restorationIdentifier!))
                    }
                } else {
                    commands.append(("u", root!.restorationIdentifier!))
                }
            }
            root = root?.presentedViewController
        }

        return commands.map({"\($0.action)\($0.id)"}).joined(separator: " ")
    }

    private func unwindToFirstSync<T: TestableController>(_ type: T.Type) {
        let e = XCTestExpectation(description: "Waiting for unwind")
        coordinator.unwindToFirst(type: type, animated: false, completion: e.fulfill)
        wait(for: [e], timeout: 1)
    }

    private func unwindToLastSync<T: TestableController>(_ type: T.Type) {
        let e = XCTestExpectation(description: "Waiting for unwind")
        coordinator.unwindToLast(type: type, animated: false, completion: e.fulfill)
        wait(for: [e], timeout: 1)
    }

    private func pushInitialSync<T: TestableController>(type: T.Type) {
        let e = XCTestExpectation(description: "Waiting for appear")
        coordinator.pushInitial(type: type, animated: false, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func pushSync<T: TestableController>(_ storyboardId: String, type: T.Type) {
        let e = XCTestExpectation(description: "Waiting \(storyboardId) for appear")
        coordinator.push(storyboardId, type: type, animated: false, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func modalInitialSync<T: TestableController>(type: T.Type, wrap: Bool = true) {
        let e = XCTestExpectation(description: "Waiting for appear")
        coordinator.modalInitial(type: type, style: .formSheet, wrapInNavigationController: wrap, animated: false, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func modalSync<T: TestableController>(_ storyboardId: String, type: T.Type, wrap: Bool = true) {
        let e = XCTestExpectation(description: "Waiting \(storyboardId) for appear")
        coordinator.modal(storyboardId, type: type, style: .formSheet, wrapInNavigationController: wrap, animated: false, prepareController: { $0.onDidAppear = e.fulfill })
        wait(for: [e], timeout: 1)
    }

    private func closeModalSync() {
        let e = XCTestExpectation(description: "Waiting for closing modal")
        coordinator.closeModal(animated: true, completion: e.fulfill )
        wait(for: [e], timeout: 1)
    }
}
