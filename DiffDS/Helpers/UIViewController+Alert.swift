import UIKit

extension UIViewController {

    func showAlert(alertTitle: String,
                           alertBody: String,
                           buttonTitle: String) {
        let alertView = UIAlertController(title: alertTitle, message: alertBody, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: buttonTitle, style: .default))
        self.present(alertView, animated: true)
    }

}
