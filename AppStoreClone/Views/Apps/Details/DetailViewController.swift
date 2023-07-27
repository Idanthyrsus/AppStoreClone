//
//  DetailViewController.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 04.07.2023.
//

import Foundation
import UIKit

class DetailViewController: UICollectionViewController {
    
    typealias DescriptionDataSource = UICollectionViewDiffableDataSource<AppSection, AnyHashable>
    
    enum AppSection {
        case description, preview, review
    }
    
    let service = APIService()
    let viewModel = DetailsViewModel()
    var result: Result?
    var album: Album?
    var screenshots: [String] = []
    var reviews: Review?
    
    fileprivate let appId: String
    private lazy var diffableDataSource = makeDiffableDataSource()
    
    // dependency injection constructor
    init(appId: String) {
        self.appId = appId
        super.init(collectionViewLayout: DetailViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = diffableDataSource
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.reuseIdentifier)
        collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: PreviewCell.reuseIdentifier)
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)
        collectionView.register(DetailViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailViewHeader.reuseIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = false
        setupDiffableDataSource()
        setupCollectionHeader()
    }
    
    func makeDiffableDataSource() -> UICollectionViewDiffableDataSource<AppSection, AnyHashable> {
        
       let cellRegistration = makeDescriptionCellRegistration()
       let reviewCellRegistration = makeReviewCellRegistration()
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, object in
        
            if let object = object as? Result {

            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: object)
            return cell
                
            } else if let object = object as? String {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCell.reuseIdentifier, for: indexPath) as? PreviewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(with: object)
                cell.layer.cornerRadius = 10
                return cell

            } else if let object = object as? Entry {
                let cell = collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: object)
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.reuseIdentifier, for: indexPath)
                return cell
            }
        }
    }
    
    private func makeDescriptionCellRegistration() -> UICollectionView.CellRegistration<AppDetailCell, Result> {
        UICollectionView.CellRegistration<AppDetailCell, Result> { cell, indexPath, item in
            cell.configure(with: item)
        }
    }
    
    private func makeReviewCellRegistration() -> UICollectionView.CellRegistration<ReviewCell, Entry> {
        UICollectionView.CellRegistration<ReviewCell, Entry> { cell, indexPath, item in
            cell.configure(with: item)
        }
    }
    
    
    private func setupDiffableDataSource() {
       
        Task {
            result = await viewModel.fetchAppDetails(id: appId).results.first
            screenshots = result?.screenshotUrls ?? []
            reviews = await viewModel.fetchReviews(id: appId)
            
            var snapshot = diffableDataSource.snapshot()
            snapshot.appendSections([.description, .preview, .review])
            snapshot.appendItems([result], toSection: .description)
            snapshot.appendItems(screenshots, toSection: .preview)
            snapshot.appendItems(reviews?.feed.entry ?? [], toSection: .review)
            
           await diffableDataSource.apply(snapshot)
        }
    }
    
    private func setupCollectionHeader() {
        
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: DetailViewHeader.reuseIdentifier, for: indexPath) as? DetailViewHeader else {
                return nil
            }
            
            let snapshot = self.diffableDataSource.snapshot()
            guard let object = self.diffableDataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            let section = snapshot.sectionIdentifier(containingItem: object)
            
            if section == .preview {
                header.configure(with: "Preview")
                return header
            } else if section == .review {
                header.configure(with: "Reviews & Ratings")
                return header
            } else {
               return nil
            }
        })
    }
   
    static private func createLayout() -> UICollectionViewCompositionalLayout {
        
        return  UICollectionViewCompositionalLayout { sectionNumber, _ in
            switch sectionNumber {
            case 0:
              return descriptionSection()
            case 1:
               return previewSection()
            default:
               return reviewSection()
            }
        }
    }
    
    static private func descriptionSection() -> NSCollectionLayoutSection {
        
        let heightDimension = NSCollectionLayoutDimension.estimated(300)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
   
        return section
    }
    
    static private func previewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: supplementaryItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        
        return section
        
    }
    
    static private func reviewSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        group.contentInsets.trailing = 16
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: supplementaryItemSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        
        return section
    }

}
