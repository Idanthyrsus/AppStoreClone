//
//  SearchResult.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation

// MARK: - Contact
struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Decodable, Hashable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Double?
    let screenshotUrls: [String]
    let artworkUrl100: String
    let formattedPrice: String
    let description: String
    let releaseNotes: String
}


