//
//  AppsViewViewModel.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 02.07.2023.
//

import Foundation

@MainActor
class AppsViewViewModel {
    
    let service = APIService()
    
    func fetchTopApps(entityType: EntityType, jsonType: JsonType, feedType: FeedType) async -> TopApp {
        
        do {
            return try await service.fetchTopApps(entityType: entityType, jsonType: jsonType, feedType: feedType)
        } catch {
          print("Network error occured")
           return TopApp(feed: Feed(title: "", results: []))
        }
    }
    
    func fetchHeaderApps() async -> [HeaderApp] {
        do {
            return try await service.fetchHeaderData()
        } catch  {
            return []
        }
    }
}
