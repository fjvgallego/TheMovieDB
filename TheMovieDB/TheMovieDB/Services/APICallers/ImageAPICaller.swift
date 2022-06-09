//
//  ImageAPICaller.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 9/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

struct ImageAPICaller {
    static let shared = ImageAPICaller()
    
    private let baseAPIStringURL = "https://image.tmdb.org/t/p"
    
    func fetchImage(withPath imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let imageQueryStringURL = "\(baseAPIStringURL)/w500\(imagePath)"
        
        QueryFetcher.fetchData(fromURL: imageQueryStringURL) { result in
            completion(result)
        }
    }
}
