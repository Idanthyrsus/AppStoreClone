//
//  AppSearchViewModel.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation

@MainActor
class AppSearchViewModel {
    
    let service = APIService()
    var apps: SearchResult?
    
    func fetchSearchResults(searchTerm: String) async -> SearchResult? {
        
        guard searchTerm != "" else {
            return SearchResult(resultCount: 0, results: [])
        }
        
        do {
            apps = try await service.fetchData(searchTerm: searchTerm, entityType: "software")
            return apps
        } catch {
            return nil
        }
    }
}

