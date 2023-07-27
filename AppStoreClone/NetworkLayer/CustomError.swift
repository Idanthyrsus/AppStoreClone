//
//  CustomError.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation

 enum CustomError: Error {
    case badURL, badURLResponse, unknown
    
    var description: String {
        switch self {
        case .badURL:
            return "Wrong URL"
        case .badURLResponse:
            return "Bad URL response"
        case .unknown:
            return "unknown error occured"
        }
    }
}
