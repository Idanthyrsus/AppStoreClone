//
//  TabBarController.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation
import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarAppearance()
        
        viewControllers = [
            createNavController(viewController: UIViewController(),
                                title: "Apps",
                                imageName: "apps"),
            createNavController(viewController: AppsSearchController(),
                                title: "Search",
                                imageName: "search"),
            createNavController(viewController: UIViewController(),
                                title: "Today",
                                imageName: "today_icon")
        ]
    }
    
    fileprivate func configureTabBarAppearance() {
        
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = true
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
          
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    fileprivate func createNavController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        
        viewController.navigationItem.title = title
        
        let navViewController = UINavigationController(rootViewController: viewController)
        navViewController.tabBarItem.title = title
        navViewController.tabBarItem.image = UIImage(named: imageName)
        navViewController.navigationBar.prefersLargeTitles = true
        
        return navViewController
    }
}

struct TabBarViewControllerContainerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: TabBarController())
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct TabBarViewController_Previews: PreviewProvider {
    static var previews: some View {
        TabBarViewControllerContainerView().colorScheme(.light) // or .dark
    }
}
