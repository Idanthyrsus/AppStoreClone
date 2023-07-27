//
//  SearchResultsCell.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import UIKit
import SnapKit
import SDWebImage

class SearchResultCell: UICollectionViewCell {
    
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.backgroundColor = .red
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private lazy var getButton: UIButton = {
        let button = UIButton(type: .system)
     //   button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.setTitle("GET", for: .normal)
        button.backgroundColor = UIColor(white: 0.95, alpha: 1)
        button.titleLabel?.textColor = .blue
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        return button
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stack = VerticalStackView(arrangedSubviews: [
            nameLabel,
            categoryLabel,
            ratingsLabel
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
    
    private lazy var overallStackView: UIStackView = {
        let stack = VerticalStackView(arrangedSubviews: [
            topStackView,
            screenshotStackView
        ],
                                      spacing: 16)
        return stack
    }()
    
    private lazy var screenshotStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
          firstScreenshotImageView,
          secondScreenshotImageView,
          thirdScreenshotImageView
        ])
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var firstScreenshotImageView = self.createScreenshotImageView()
    private lazy var secondScreenshotImageView = self.createScreenshotImageView()
    private lazy var thirdScreenshotImageView = self.createScreenshotImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createScreenshotImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
        return imageView
    }
    
   private func setupComponents() {
        
        self.addSubview(overallStackView)
        
        overallStackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(self.snp.bottom).offset(-16)
            make.leading.equalTo(self.snp.leading).offset(16)
            make.trailing.equalTo(self.snp.trailing).offset(-16)
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
    
    func configureCell(with data: Result) {
        nameLabel.text = data.trackName
        categoryLabel.text = data.primaryGenreName
        
        let iconUrl = URL(string: data.artworkUrl100)
        appIconImageView.sd_setImage(with: iconUrl)
        
        let urlArray: [URL?] = data.screenshotUrls.map { URL(string: $0) }
        
        firstScreenshotImageView.sd_setImage(with: urlArray[0])
        if urlArray.count > 1 {
            secondScreenshotImageView.sd_setImage(with: urlArray[1])
        }
        if urlArray.count > 2 {
            thirdScreenshotImageView.sd_setImage(with: urlArray[2])
        }
        
        if let rating = data.averageUserRating {
            ratingsLabel.text =  "\(rating.rounded(.awayFromZero))"
        }
    }
}
