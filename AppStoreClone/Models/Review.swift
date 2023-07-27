//
//  Review.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 09.07.2023.
//

import Foundation

struct Review: Decodable, Hashable  {
   
    let feed: ReviewFeed

}

struct ReviewFeed: Decodable, Hashable {
  
    let entry: [Entry]
}

struct Entry: Decodable, Hashable  {
  
    let author: Author
    let title: Label
    let content: Label
    
    
}

struct Author: Decodable, Hashable {
    
    let name: Label
}

struct Label: Decodable, Hashable {
    
    let label: String
}


