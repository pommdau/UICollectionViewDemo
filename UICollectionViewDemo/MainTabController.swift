//
//  MainTabController.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/12.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        self.configureViewControllers()
        self.congigureUI()
    }
    
    // MARK: - Selectors
    
    // MARK: - API

    // MARK: - Helpers
    
    func congigureUI() {
        self.delegate = self
    }
    
    func configureViewControllers() {
        
        let feed = FirstCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
//        let list = ListController(style: .plain)
//        let nav2 = templateNavigationController(image: UIImage(named: "list_unselected"), rootViewController: list)
//
//        let search = SearchController(style: .plain)
//        let nav3 = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: search)
        
//        viewControllers = [nav1, nav2, nav3]
        viewControllers = [nav1]
    }

    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
    
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("DEBUG: func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)")
    }
}
