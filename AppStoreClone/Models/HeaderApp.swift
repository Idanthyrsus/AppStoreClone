//
//  HeaderApp.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 02.07.2023.
//

import Foundation

struct HeaderApp: Decodable, Hashable {
    let id: String
    let name: String
    let tagline: String
    let imageUrl: String
}
