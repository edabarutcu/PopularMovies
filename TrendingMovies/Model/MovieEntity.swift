//
//  MovieEntity.swift
//  TrendingMovies
//
//  Created by EDA BARUTÇU 10.01.2022.
//

import Foundation

struct MovieEntity: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
    struct Movie: Decodable {
        let id: Int
        let title: String
        let poster: String?
        let releaseDate: String
        let rating: Double
        
        enum CodingKeys: String, CodingKey {
            case id
            case title = "original_title"
            case poster = "poster_path"
            case releaseDate = "release_date"
            case rating = "vote_average"
        }
    }
}
