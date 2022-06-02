//
//  TabBarController.swift
//  CryptoApp
//
//  Created by Volodymyr Mendyk on 26/05/2022.
//

import Foundation
import UIKit


class TabBarController: UIViewController {
    
    let tabBarVC = UITabBarController()
    
    override func viewDidLoad() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        let homeVC = UINavigationController(rootViewController: ViewController())
        let cryptoDetailsVC = UINavigationController(rootViewController: CryptoDetailsViewController())
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.setViewControllers([homeVC,
                                     cryptoDetailsVC], animated: true)
        present(tabBarVC, animated: true)
    }
}
