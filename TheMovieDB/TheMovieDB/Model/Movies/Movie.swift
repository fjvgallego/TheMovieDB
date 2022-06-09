//
//  Movie.swift
//  TheMovieDB
//
//  Created by Francisco Javier Gallego Lahera on 8/6/22.
//  Copyright © 2022 Francisco Javier Gallego Lahera. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let overview: String
    let voteAverage: Double
    let posterPath: String?
    let releaseDate: String?
    
    static let exampleMovies = [
        Movie(id: 1, title: "A Space Odyssey",
              overview: "The greatest film ever made began with the meeting of two brilliant minds: Stanley Kubrick and sci-fi seer Arthur C Clarke.",
              voteAverage: 4.8, posterPath: "", releaseDate: "1968-10-17"),
        Movie(id: 2, title: "The Godfather",
              overview: "From the wise guys of Goodfellas to The Sopranos, all crime dynasties that came after The Godfather are descendants of the Corleones: Francis Ford Coppola’s magnum opus is the ultimate patriarch of the Mafia genre.",
              voteAverage: 5, posterPath: "", releaseDate: "1972-10-20"),
        Movie(id: 3, title: "Citizen Kane",
              overview: "Citizen Kane always finds a way to renew itself for a new generation of film lovers.",
              voteAverage: 4.4, posterPath: "", releaseDate: "1941-2-11")
    ]
}

// MARK: - Serialization -

extension Movie: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.posterPath = try? container.decode(String.self, forKey: .posterPath)
        self.releaseDate = try? container.decode(String.self, forKey: .releaseDate)
    }
}
