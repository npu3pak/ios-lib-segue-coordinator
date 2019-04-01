
import UIKit
import SegueCoordinator

class FirstViewController: UIViewController {
    
    var onShowSecond: (() -> Void)?
    
    @IBAction func onShowSecondButtonClick(_ sender: Any) {
        onShowSecond?()
    }
}

