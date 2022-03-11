//
//  UIViewControllerExtensions.swift
//  CardScanner
//
//  Created by Filip Zeman on 08.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? ShowedViewController {
            return nextResponder
        }
        else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        }
        else {
            return nil
        }
    }
}
