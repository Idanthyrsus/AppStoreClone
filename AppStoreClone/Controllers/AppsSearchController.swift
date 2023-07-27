//
//  AppsSearchController.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

class AppsSearchController: UICollectionViewController {
    
    var data: SearchResult?
    let viewModel = AppSearchViewModel()
    var timer: Timer?
   
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        return search
    }()
    
    private lazy var enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.textAlignment = .center
        label.text = "Please enter search term above..."
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.reuseIdentifier)
        setupSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterSearchTermLabel.isHidden = false
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = data?.results.count != 0
        return data?.results.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.reuseIdentifier, for: indexPath) as? SearchResultCell else {
            fatalError("couldn't create cell")
        }
        
        let newViewModel = data?.results[indexPath.item]
        
        if let viewModel = newViewModel {
            cell.configureCell(with: viewModel)
        }
        
        return cell
    }
    
    private func fetchItunesApps(by searchTerm: String) {
        Task {
            data = await viewModel.fetchSearchResults(searchTerm: searchTerm)
            await MainActor.run(body: {
                collectionView.reloadData()
            })
        }
    }

    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupLabel() {
        view.addSubview(enterSearchTermLabel)
        
        enterSearchTermLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
}

extension AppsSearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.fetchItunesApps(by: searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.fetchItunesApps(by: searchBar.text ?? "")
    }
}

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 350)
    }
}


struct AppsSearchViewControllerContainerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
       UINavigationController(rootViewController: TabBarController())
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct AppsSearchViewController_Previews: PreviewProvider {
    static var previews: some View {
        AppsSearchViewControllerContainerView().colorScheme(.light) // or .dark
    }
}
