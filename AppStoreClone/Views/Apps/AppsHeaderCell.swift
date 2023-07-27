//
//  AppsHeaderCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 01.07.2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class AppsHeaderCell: UICollectionViewCell {
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        label.textColor = .blue
        label.font = .boldSystemFont(ofSize: 12)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Keeping up with friends is faster than ever"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var vStack: UIStackView = {
        let vStack = VerticalStackView(arrangedSubviews: [
            companyLabel,
            titleLabel,
            imageView
        ], spacing: 12)
        
        return vStack
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vStack)
        
        vStack.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with companyName: String, tagline: String, imageUrlString: String) {
        
        companyLabel.text = companyName
        titleLabel.text = tagline
        
        let url = URL(string: imageUrlString)
        imageView.sd_setImage(with: url)
    }
}
