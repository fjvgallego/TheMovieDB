//
//  MovieFetchTests.swift
//  TheMovieDBTests
//
//  Created by Francisco Javier Gallego Lahera on 10/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import XCTest
@testable import TheMovieDB

class MovieFetchTests: XCTestCase {
    
    var movies: [Movie]!
    var image: UIImage!
    
    override func tearDown() {
        movies = nil
        super.tearDown()
    }

    func test_fetchMovieDetail() throws {
        let movieExpectation = expectation(description: "MovieFetch")
        let movieImageExpectation = expectation(description: "MovieImageFetch")
        
        // Fetch movies with this search text.
        let searchText = "Godfather"
        MovieAPICaller.shared.fetchMovies(withQuery: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure: XCTFail()
            case .success(let fetchedMovies):
                self.movies = fetchedMovies
                // Expectation fulfilled: movies successfully fetched.
                movieExpectation.fulfill()
                
                do {
                    // If no movies were fetched, the image can't be fetched either.
                    try XCTSkipUnless(self.movies != nil && self.movies.isEmpty == false)
                    // Pick a random movie, take its posterPath (if it exists) and fetch the image.
                    let randomMovie = self.movies.randomElement()!
                    if let imagePath = randomMovie.posterPath {
                        ImageAPICaller.shared.fetchImage(withPath: imagePath) { result in
                            switch result {
                            case .failure: XCTFail()
                            case .success(let data):
                                if let image = UIImage(data: data) {
                                    self.image = image
                                    movieImageExpectation.fulfill()
                                } else {
                                    XCTFail()
                                }
                            }
                        }
                    } else {
                        // If the posterPath doesn't exist, then
                        movieImageExpectation.fulfill()
                    }
                } catch { }
            }
        }

        waitForExpectations(timeout: 6, handler: nil)
    }
}
