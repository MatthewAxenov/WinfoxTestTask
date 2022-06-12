//
//  Toast.swift
//  Registration
//
//  Created by Матвей on 10.06.2022.
//

import Foundation
import UIKit

extension UIViewController {

    func showToast(message : String, overlayView: UIView) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: 30, width: 300, height: 70))
    toastLabel.center = view.center
    toastLabel.backgroundColor = .tintColor
    toastLabel.textColor = UIColor.white
    toastLabel.font = .systemFont(ofSize: 18)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
        overlayView.isHidden = true
        })
    }
}
