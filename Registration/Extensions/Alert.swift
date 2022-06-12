//
//  AlertOk.swift
//  Registration
//
//  Created by Матвей on 15.04.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
