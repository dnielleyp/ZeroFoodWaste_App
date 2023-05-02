//
//  UIViewController+displayMessage.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 2/5/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func displayMessage(title: String, message: String) {
    
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
}
