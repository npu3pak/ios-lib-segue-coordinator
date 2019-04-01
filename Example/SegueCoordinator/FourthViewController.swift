
import UIKit

class FourthViewController: UIViewController {

    var onUnwindToRoot: (()->Void)?
    var onUnwindToThird: (()->Void)?
    var onUnwindToFourth: (()->Void)?
    var onUnwindToFirstNavigation: (()->Void)?

    @IBAction private func onUnwindToRootButtonClick(_ sender: Any) {
        onUnwindToRoot?()
    }

    @IBAction private func onUnwindToThirdButtonClick(_ sender: Any) {
        onUnwindToThird?()
    }

    @IBAction private func onUnwindToFourthButtonClick(_ sender: Any) {
        onUnwindToFourth?()
    }

    @IBAction private func onUnwindToFirstNavigationButtonClick(_ sender: Any) {
        onUnwindToFirstNavigation?()
    }
}
