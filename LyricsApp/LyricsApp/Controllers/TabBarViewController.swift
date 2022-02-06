//
//  TabBarViewController.swift
//  LyricsApp
//
//  Created by Obed Garcia on 4/2/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configure()
    }
    
    private func configure() {
        let searchVC = SearchViewController()
        let chartVC = ChartsViewController()
        let bookmarkVC = BookmarkListViewController() // BookmarkedLyricViewController()

        chartVC.title = "Charts"
        bookmarkVC.title = "Saved"

        chartVC.navigationItem.largeTitleDisplayMode = .always
        bookmarkVC.navigationItem.largeTitleDisplayMode = .always

        let nav1 = UINavigationController(rootViewController: searchVC)
        let nav2 = UINavigationController(rootViewController: chartVC)
        let nav3 = UINavigationController(rootViewController: bookmarkVC)

        nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Charts", image: UIImage(systemName: "flame"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 1)

        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: false)
    }
    
    private func configureAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tabBar.standardAppearance = appearance
    }
}
