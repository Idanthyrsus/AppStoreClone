//
//  Album.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 09.07.2023.
//

import Foundation

// MARK: - Feed
struct AlbumFeed: Codable {
    let resultCount: Int
    let results: [Album]
}

// MARK: - Result
struct Album: Codable, Hashable {
    let wrapperType, collectionType: String
    let artistID, collectionID, amgArtistID: Int
    let artistName, collectionName, collectionCensoredName: String
    let artistViewURL, collectionViewURL: String
    let artworkUrl60, artworkUrl100: String
    let collectionPrice: Double
    let collectionExplicitness, contentAdvisoryRating: String
    let trackCount: Int
    let copyright, country, currency: String
    let releaseDate: Date
    let primaryGenreName: String

    enum CodingKeys: String, CodingKey {
        case wrapperType, collectionType
        case artistID = "artistId"
        case collectionID = "collectionId"
        case amgArtistID = "amgArtistId"
        case artistName, collectionName, collectionCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, collectionExplicitness, contentAdvisoryRating, trackCount, copyright, country, currency, releaseDate, primaryGenreName
    }
}
