//
//  AppDetailCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 05.07.2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import SwiftUI

class AppDetailCell: UICollectionViewCell {
    
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "App Name"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var priceButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 32 / 2
        button.setTitle("$4.99", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var whatsNewLabel: UILabel = {
        let label = UILabel()
        label.text = "What's New"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var releaseNotesLabel: UILabel = {
        let label = UILabel()
        label.text = "Release Notes"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.contentCompressionResistancePriority(for: .vertical)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElements() {
        addSubviews([
        appIconImageView,
        nameLabel,
        priceButton,
        whatsNewLabel,
        releaseNotesLabel
        ])
        
        appIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(140)
            make.height.equalTo(140)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(180)
        }
        
        priceButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(appIconImageView.snp.trailing).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(80)
        }
        
        whatsNewLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(160)
            make.height.equalTo(30)
        }
        
        releaseNotesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(whatsNewLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func configure(with model: Result) {
        if let url = URL(string: model.artworkUrl100) {
            appIconImageView.sd_setImage(with: url)
        }
     
        nameLabel.text = model.trackName
        priceButton.setTitle(model.formattedPrice, for: .normal)
        releaseNotesLabel.text = model.releaseNotes
    }
    
    func configure(with model: Album) {
        if let url = URL(string: model.artworkUrl100) {
            appIconImageView.sd_setImage(with: url)
        }
     
        nameLabel.text = model.artistName
        priceButton.setTitle(model.currency, for: .normal)
        releaseNotesLabel.text = model.collectionName
    }
}

