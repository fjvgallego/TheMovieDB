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
    private let imageSizeURLComponent = "/w500"
    
    /// Fetch a movie image from its path.
    /// - imagePath: the movie image path.
    /// - completion: if the query succeeds, it returns the image data. It needs to be converted to an UIImage. Otherwise, it returns an error.
    func fetchImage(withPath imagePath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let imageQueryStringURL = "\(baseAPIStringURL)\(imageSizeURLComponent)\(imagePath)"
        
        QueryFetcher.fetchData(fromURL: imageQueryStringURL) { result in
            completion(result)
        }
    }
}
