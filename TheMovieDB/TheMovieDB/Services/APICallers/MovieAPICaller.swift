//
//  MovieAPICaller.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

class MovieAPICaller {
    static let shared = MovieAPICaller()
    
    private let baseAPIStringURL = "https://api.themoviedb.org/3?api_key=\(Constants.kAPIKey)"
    private var searchURL: String { "\(baseAPIStringURL)/search/movie" }
    
    func fetchMovies(withQuery query: String, page: Int = 1, completion: @escaping (Result<MoviesResult, Error>) -> Void) {
        // In the query, spaces must be replaced with %20. Otherwise, the query will fail.
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        // If the query text is empty, no movies can be shown -> the API forces to pass in a non-empty search text.
        guard formattedQuery.isEmpty == false, Constants.kAPIMoviePagesRange.contains(page) else {
            completion(.failure(APIFetchError.queryError))
            return
        }
        
        let searchQueryStringURL = "\(searchURL)&page=\(page)&query=\(formattedQuery)"
        
        // Start fetching the movies data, then parse it if there's no errors.
        QueryFetcher.fetchData(fromURL: searchQueryStringURL) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                // Parse the fetched data, if possible.
                do {
                    let moviesResult = try JSONDecoder().decode(MoviesResult.self, from: data)
                    if moviesResult.movies.isEmpty {
                        completion(.failure(APIFetchError.emptyData))
                    } else {
                        completion(.success(moviesResult))
                    }
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
    }
}
