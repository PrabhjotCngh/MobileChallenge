//
//  Utility.swift
//  LeagueMobileChallenge
//
//  Created by Prabh on 2022-05-19.
//  Copyright © 2022 Kelvin Lau. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    //MARK: - Static method to display alertView on any controller
    static func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: AlertViewConstants.ok, style: .default, handler: nil)
            alertController.addAction(defaultAction)
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }
        viewController.present(alertController, animated: true, completion: nil)
    }
}
