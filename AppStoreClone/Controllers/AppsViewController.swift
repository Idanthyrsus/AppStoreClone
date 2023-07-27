//
//  AppsViewController.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 27.06.2023.
//

import Foundation
import UIKit
import SwiftUI

class AppsViewController: UICollectionViewController {
    
    enum AppSection {
        case headerApp,
             freeApp,
             book,
             album,
             paidApp
    }
    
    typealias HeaderDataSource = UICollectionViewDiffableDataSource<AppSection, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<AppSection, HeaderApp>
    
    let viewModel = AppsViewViewModel()
  
    var topApps: [TopApp] = []
    var headerApps: [HeaderApp] = []
    var topFree: TopApp?
    var books: TopApp?
    var albums: TopApp?
    var topPaidApps: TopApp?
    
    init() {
        
        super.init(collectionViewLayout: AppsViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: AppsHeaderCell.reuseIdentifier)
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeader.reuseIdentifier)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: AppRowCell.reuseIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Fetch books", style: .plain, target: self, action: #selector(handleBooksFetch))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        setupDiffableDataSource()
        setupCollectionHeader()

    }
    
    @objc fileprivate func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.book])
        diffableDataSource.apply(snapshot)
    }
    
    @objc fileprivate func handleBooksFetch() {
        Task {
            books = await viewModel.fetchTopApps(entityType: .books, jsonType: .books, feedType: .topPaid)
            
            var snapshot = diffableDataSource.snapshot()
            if !snapshot.sectionIdentifiers.contains(.book) {
                snapshot.insertSections([.book], afterSection: .headerApp)
                snapshot.appendItems(books?.feed.results ?? [], toSection: .book)
                await diffableDataSource.apply(snapshot, animatingDifferences: true)
            }
             
        }
    }
    
   lazy var diffableDataSource = HeaderDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
       if let object = object as? HeaderApp {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderCell.reuseIdentifier, for: indexPath) as? AppsHeaderCell else {
               fatalError()
           }
          cell.configureCell(with: object.name,
                             tagline: object.tagline,
                             imageUrlString: object.imageUrl)
        
           return cell
           
       } else if let object = object as? FeedResult {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseIdentifier, for: indexPath) as? AppRowCell else {
               fatalError()
           }
           cell.configureCell(with: object)
           cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
           return cell
       }
      
       return nil
      
    })
    
    @objc func handleGet(buuton: UIButton) {
        
        var superview = buuton.superview
        
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else {
                    return
                }
                guard let tappedObject = diffableDataSource.itemIdentifier(for: indexPath) else {
                    return
                }
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([tappedObject])
                diffableDataSource.apply(snapshot)
            }
            superview = superview?.superview
        }
    }
    
    private func setupCollectionHeader() {
        
        collectionView.dataSource = diffableDataSource
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: CompositionalHeader.reuseIdentifier, for: indexPath) as? CompositionalHeader else {
                return nil
            }
            
            let snapshot = self.diffableDataSource.snapshot()
            guard let object = self.diffableDataSource.itemIdentifier(for: indexPath) else {
                return nil
            }
         
            let section = snapshot.sectionIdentifier(containingItem: object)
            
            switch section {
                
            case .freeApp:
                if let headerTitle = self.topFree?.feed {
                    
                    header.configure(with: headerTitle)
                }
              
                return header
                
            case .book:
                if let headerTitle = self.books?.feed {
                    
                    header.configure(with: headerTitle)
                }
              
                return header
                
            case .album:
                if let headerTitle = self.albums?.feed {
                    
                    header.configure(with: headerTitle)
                }
              
                return header
                
            default:
                
                if let headerTitle = self.topPaidApps?.feed {
                    
                    header.configure(with: headerTitle)
                }
              
                return header
            }
        })
    }
    
    private func  setupDiffableDataSource() {
        
        Task {
            headerApps = await viewModel.fetchHeaderApps()
            topFree = await viewModel.fetchTopApps(entityType: .apps,
                                                   jsonType: .apps,
                                                   feedType: .topFree)
       
            albums = await viewModel.fetchTopApps(entityType: .music, jsonType: .albums, feedType: .mostPlayed)
            topPaidApps = await viewModel.fetchTopApps(entityType: .apps, jsonType: .apps, feedType: .topPaid)
           
            var snapshot = diffableDataSource.snapshot()
            snapshot.appendSections([.headerApp, .freeApp, .paidApp, .album])
            snapshot.appendItems(headerApps, toSection: .headerApp)
            snapshot.appendItems(topFree?.feed.results ?? [], toSection: .freeApp)
            snapshot.appendItems(topPaidApps?.feed.results ?? [], toSection: .paidApp)
            snapshot.appendItems(albums?.feed.results ?? [], toSection: .album)
            await diffableDataSource.apply(snapshot)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id: String
        let object =  self.diffableDataSource.itemIdentifier(for: indexPath)
        
        if let object = object as? HeaderApp {
             id = object.id
             let appDetailController = DetailViewController(appId: id)
            appDetailController.navigationItem.title = object.name
             navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            id = object.id
            let appDetailController = DetailViewController(appId: id)
            appDetailController.navigationItem.title = object.name
            navigationController?.pushViewController(appDetailController, animated: true)
        } 
    }
    
//    private func fetchData() async {
//
//        async let headerApps = viewModel.fetchHeaderApps()
//
//        let header = await headerApps
//        self.headerApps.append(contentsOf: header)
//
//        async let fetchApps = viewModel.fetchTopApps(entityType: .apps,
//                                                     jsonType: .apps,
//                                                     feedType: .topFree)
//        async let fetchPaidApps = viewModel.fetchTopApps(entityType: .apps,
//                                                      jsonType: .apps,
//                                                      feedType: .topPaid)
//        async let fetchMusic = viewModel.fetchTopApps(entityType: .music,
//                                                      jsonType: .albums,
//                                                      feedType: .mostPlayed)
//        let (apps, books, musicAlbums) = await (fetchApps, fetchPaidApps, fetchMusic)
//        self.topApps.append(contentsOf: [apps, books, musicAlbums])
//    }
    
   static private func createLayout() -> UICollectionViewCompositionalLayout {
       
       return UICollectionViewCompositionalLayout { sectionNumber, _ in
           
           switch sectionNumber {
           case 0:
             return topSection()
           default:
               return feedSection()
           }
       }
    }
    
    static private func topSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    static private func feedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        
        section.boundarySupplementaryItems = [
         .init(layoutSize: supplementaryItemSize,
               elementKind: UICollectionView.elementKindSectionHeader,
               alignment: .topLeading)
        ]
        return section
    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//      //  1 + topApps.count
//        0
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return headerApps.count
//        default:
//            return topApps[section-1].feed.results.count
//        }
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        switch indexPath.section {
//
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsHeaderCell.reuseIdentifier, for: indexPath) as? AppsHeaderCell else {
//                fatalError()
//            }
//
//            let headerData = headerApps[indexPath.item]
//
//            cell.configureCell(with: headerData.name,
//                               tagline: headerData.tagline,
//                               imageUrlString: headerData.imageUrl)
//            return cell
//        default:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppRowCell.reuseIdentifier, for: indexPath) as? AppRowCell else {
//                fatalError()
//            }
//
//            let feedResult = topApps[indexPath.section-1].feed.results[indexPath.item]
//            cell.configureCell(with: feedResult)
//
//            return cell
//        }
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CompositionalHeader.reuseIdentifier, for: indexPath) as? CompositionalHeader else {
//            fatalError()
//        }
//
//        let headerTitle = topApps[indexPath.section-1].feed
//        header.configure(with: headerTitle)
//
//        return header
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        let name: String
//
//        switch indexPath.section {
//        case 0:
//            appId = headerApps[indexPath.item].id
//            name = headerApps[indexPath.item].name
//        default:
//            appId = topApps[indexPath.section-1].feed.results[indexPath.item].id
//            name = topApps[indexPath.section-1].feed.results[indexPath.item].name
//        }
//
//        let controller = DetailViewController()
//        controller.appId = appId
//        controller.title = name
//        navigationController?.pushViewController(controller, animated: true)
//    }
}

struct AppsView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = AppsViewController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

struct AppsViewController_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
