//
//  TopApp.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 02.07.2023.
//

import Foundation

struct TopApp: Codable, Hashable {
    let feed: Feed
}

struct Feed: Codable, Hashable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Codable, Hashable {
    let id, name, artistName, artworkUrl100: String
}
