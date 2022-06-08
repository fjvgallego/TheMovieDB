//
//  Movie.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

struct Movie {
    let title: String
    let description: String
    let voteAverage: Double
    let posterPath: String
    let year: Int
    
    static let exampleMovies = [
        Movie(title: "A Space Odyssey",
              description: "The greatest film ever made began with the meeting of two brilliant minds: Stanley Kubrick and sci-fi seer Arthur C Clarke.",
              voteAverage: 4.8, posterPath: "", year: 1968),
        Movie(title: "The Godfather",
              description: "From the wise guys of Goodfellas to The Sopranos, all crime dynasties that came after The Godfather are descendants of the Corleones: Francis Ford Coppola’s magnum opus is the ultimate patriarch of the Mafia genre.",
              voteAverage: 5, posterPath: "", year: 1972),
        Movie(title: "Citizen Kane",
              description: "Citizen Kane always finds a way to renew itself for a new generation of film lovers.",
              voteAverage: 4.4, posterPath: "", year: 1941)
    ]
}
