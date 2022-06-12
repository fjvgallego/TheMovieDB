//
//  QueryFetcher.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 9/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

struct QueryFetcher {
    /// Requests any kind of data, and if it succeeds it returns it to be decoded. If it fails, it returns an error.
    /// queryStringURL: the url in string format where to request it.
    /// completion: if it succeeds, it returns de raw data. If it fails, an error is returned.
    static func fetchData(fromURL queryStringURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        // Check if the query URL exists.
        guard let queryURL = URL(string: queryStringURL) else {
            completion(.failure(APIFetchError.invalidURL(url: queryStringURL)))
            return
        }
        
        // Execute the query.
        let task = URLSession.shared.dataTask(with: queryURL) { data, response, error in
            // Check there's no error in the request.
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Check if the response is successful.
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(APIFetchError.badResponse))
                return
            }

            // Check if there's fetched data available.
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(APIFetchError.dataNotFound))
            }
        }
        
        task.resume()
    }
}
