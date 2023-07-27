//
//  APIService.swift
//  AppStoreClone
//
//  Created by Alexander Korchak on 24.06.2023.
//

import Foundation

class APIService {
    
    func fetchData<T: Decodable>(searchTerm: String, entityType: String) async throws -> T {
        
        guard let url = createURL(for: searchTerm, entityType: entityType) else {
            throw CustomError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard checkResponse(response: response) else {
                throw CustomError.badURLResponse
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch  {
            throw CustomError.unknown
        }
    }
    
    func fetchTopApps<T: Decodable>(entityType: EntityType,
                                    jsonType: JsonType,
                                    feedType: FeedType) async throws -> T {
        guard let url = createUrl(for: entityType,
                                  jsonType: jsonType,
                                  feedType: feedType.rawValue) else {
            throw CustomError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard checkResponse(response: response) else {
                throw CustomError.badURLResponse
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw CustomError.unknown
        }
    }
    
    
    func fetchHeaderData<T: Decodable>() async throws -> [T] {
        
        guard let url = URL(string: "https://api.letsbuildthatapp.com/appstore/social") else {
            throw CustomError.badURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard checkResponse(response: response) else {
                throw CustomError.badURLResponse
            }
            
            let result = try JSONDecoder().decode([T].self, from: data)
            return result
        } catch  {
            throw CustomError.unknown
        }
    }
    
    func fetchDetailsData<T: Decodable>(id: String, url: URL) async throws -> T {
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard checkResponse(response: response) else {
                throw CustomError.badURLResponse
            }
            
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch  {
            throw CustomError.unknown
        }
    }
    
    private func checkResponse(response: URLResponse) -> Bool {
        if let response = (response as? HTTPURLResponse) {
            return response.statusCode >= 200 && response.statusCode < 300
        }
        return false
    }
    
    func createDetailsScreenURL(for id: String) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"

        let queryItems = [
           URLQueryItem(name: "id", value: id)
        ]

        components.queryItems = queryItems
        return components.url
    }
    
    func createURL(for searchTerm: String, entityType: String) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/search"
        
        let queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "entity", value: entityType)
        ]
        
        components.queryItems = queryItems
        return components.url
    }
    
    func createUrl(for entityType: EntityType, jsonType: JsonType, feedType: String) -> URL? {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rss.applemarketingtools.com"
        components.path = "/api/v2/us/\(entityType)/\(feedType)/50/\(jsonType).json"
        
        return components.url
    }
    
    func createReviewUrl(id: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/rss/customerreviews/page=1/id=\(id)/sortby=mostrecent/json"
        
        let queryItems = [
            URLQueryItem(name: "l", value: "en"),
            URLQueryItem(name: "cc", value: "us")
        ]
        
        components.queryItems = queryItems
        return components.url
    }
}
