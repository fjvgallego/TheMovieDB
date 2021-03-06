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
    
    private let baseAPIStringURL = "https://api.themoviedb.org/3"
    private var searchURL: String { "\(baseAPIStringURL)/search/movie?api_key=\(Constants.kAPIKey)" }
    
    /// Fetch a movies result (conformed by a page and movies list):
    /// - query: text that the user enters to search any movies.
    /// - page: the page where to look for movies. This allows pagination. By default, the first page is the lowest admitted by the API.
    /// - completion: if succeeds, returns a MoviesResult object, with the list of movies. Otherwise, returns an error.
    func fetchMovies(withQuery query: String, page: Int = Constants.kAPIMoviePagesRange.lowerBound, completion: @escaping (Result<MoviesResult, Error>) -> Void) {
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
