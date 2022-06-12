//
//  APIFetchError.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 9/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

enum APIFetchError: Error {
    case invalidURL(url: String)
    case badResponse
    case dataNotFound
    case queryError
    case emptyData
    
    var description: String {
        switch self {
        case .invalidURL(let url): return "The provided URL is invalid: \(url)"
        case .badResponse: return "Couldn't connect to server."
        case .dataNotFound: return "Couldn't fetch any data."
        case .queryError: return "Search text can't be empty."
        case .emptyData: return "No results found."
        }
    }
}
