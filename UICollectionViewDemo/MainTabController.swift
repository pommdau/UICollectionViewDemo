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
    
        let simple = SimpleCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let tabIcon_01 = UIImage(systemName: "1.circle")
        let navigation_01 = templateNavigationController(image: tabIcon_01, rootViewController: simple)
        
        let pinterest = PinterestCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let tabIcon_02 = UIImage(systemName: "2.circle")
        let navigation_02 = templateNavigationController(image: tabIcon_02, rootViewController: pinterest)
    
        let album = AlbumCollectionViewController(nibName: nil, bundle: nil)
        let tabIcon_03 = UIImage(systemName: "3.circle")
        let navigation_03 = templateNavigationController(image: tabIcon_03, rootViewController: album)
        
        let diffable = DiffableDatasourceCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let tabIcon_04 = UIImage(systemName: "4.circle")
        let navigation_04 = templateNavigationController(image: tabIcon_04, rootViewController: diffable)
        
        viewControllers = [navigation_04, navigation_01, navigation_02, navigation_03]
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
