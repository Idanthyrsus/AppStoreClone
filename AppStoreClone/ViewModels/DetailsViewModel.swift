//
//  DetailsViewModel.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 05.07.2023.
//

import Foundation

class DetailsViewModel {
    
    let service = APIService()
    
    func fetchAppDetails(id: String) async -> SearchResult {
        guard let url = service.createDetailsScreenURL(for: id) else {
            return SearchResult(resultCount: 0, results: [])
        }
        do {
            return try await service.fetchDetailsData(id: id, url: url)
        } catch {
            return SearchResult(resultCount: 0, results: [])
        }
    }
    
    func fetchReviews(id: String) async -> Review {
        guard let url = service.createReviewUrl(id: id) else {
            return Review(feed: ReviewFeed(entry: []))
        }
        
        do {
            let result: Review = try await service.fetchDetailsData(id: id, url: url)
            return result
        } catch {
            return Review(feed: ReviewFeed(entry: []))
        }
    }
   
    
//    func fetchAlbumDetails(id: String) async -> AlbumFeed {
//        do {
//            return try await service.fetchDetailsData(id: id)
//        } catch {
//           return AlbumFeed(resultCount: 0, results: [])
//        }
//    }
}
