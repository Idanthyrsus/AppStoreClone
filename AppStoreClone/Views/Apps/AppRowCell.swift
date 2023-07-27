//
//  AppRowCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 01.07.2023.
//

import Foundation
import UIKit
import SnapKit

class AppRowCell: UICollectionViewCell {
    
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
     lazy var getButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 16
        button.setTitle("GET", for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.titleLabel?.textColor = .blue
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = VerticalStackView(arrangedSubviews: [
            nameLabel,
            companyLabel
        ])
        return stack
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            appIconImageView,
            labelsStackView,
            getButton
        ])
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
         
         self.addSubview(topStackView)
         
         topStackView.snp.makeConstraints { make in
             make.top.equalTo(self.snp.top)
             make.bottom.equalTo(self.snp.bottom)
             make.leading.equalTo(self.snp.leading)
             make.trailing.equalTo(self.snp.trailing)
         }
         
         appIconImageView.snp.makeConstraints { make in
             make.width.equalTo(64)
             make.height.equalTo(64)
         }
         
         getButton.snp.makeConstraints { make in
             make.width.equalTo(80)
             make.height.equalTo(32)
         }
     }
    
    func configureCell(with result: FeedResult) {
        nameLabel.text = result.name
        companyLabel.text = result.artistName
        
        let iconUrl = URL(string: result.artworkUrl100)
        appIconImageView.sd_setImage(with: iconUrl)
        
    }
}
