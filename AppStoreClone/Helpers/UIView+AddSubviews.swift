//
//  UIView+AddSubviews.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation
import UIKit

extension UIView {

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(self.addSubview)
    }

}
