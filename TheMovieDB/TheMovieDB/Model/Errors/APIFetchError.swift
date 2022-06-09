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
    case noData
    
    var description: String {
        switch self {
        case .invalidURL(let url): return "The provided URL is invalid: \(url)"
        case .badResponse: return "Bad response."
        case .noData: return "Couldn't fetch any data."
        }
    }
}
