//
//  UIStackView+Extensions.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 05.07.2023.
//

import Foundation
import UIKit

extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView], customSpacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.spacing = customSpacing
    }
}
