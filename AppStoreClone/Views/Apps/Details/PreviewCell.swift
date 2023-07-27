//
//  PreviewCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 08.07.2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class PreviewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElements() {
        addSubview(imageView)
    
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with urlString: String) {
        let url = URL(string: urlString)
        imageView.sd_setImage(with: url)
    }
}
