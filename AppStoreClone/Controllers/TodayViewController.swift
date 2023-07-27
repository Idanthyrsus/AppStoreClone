//
//  ViewController.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import UIKit
import SwiftUI

class TodayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

struct ContentViewControllerContainerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TodayViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        return TodayViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentViewController_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewControllerContainerView().colorScheme(.light) // or .dark
    }
}
