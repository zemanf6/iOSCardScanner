//
//  TabBarController.swift
//  CardScanner
//
//  Created by Filip Zeman on 18.11.2021.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    public init() {
        super.init(nibName: nil, bundle: nil)

        prepareViewControllers()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareViewControllers() {
        self.viewControllers = [
            prepareViewController(title: "Scanner", imageName: "qrcode",
                                  viewController: ScannerViewController()),
            prepareViewController(title: "Create", imageName: "plus.circle",
                              viewController: CreatingViewController())]
    }

    private func prepareViewController(title: String?, imageName: String?,
                                       viewController: UIViewController)
    -> UINavigationController {
        viewController.tabBarItem = prepareTabBarItem(title: title, imageName: imageName)
        return UINavigationController(rootViewController: viewController)
    }
    private func prepareTabBarItem(title: String?, imageName: String?) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.title = title
        tabBarItem.image = UIImage(systemName: imageName ?? "")

        return tabBarItem
    }
}
