//
//  Movie.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/11.
//

import Foundation

struct Genre: Codable {
    let id: Int
    let name: String
}

struct ProductionCompany: Codable {
    let name: String
    let id: Int
}

struct ProductionCountry: Codable {
    let iso_3166_1: String
    let name: String
}

struct SpokenLanguage: Codable {
    let iso_639_1: String
    let name: String
}


struct Movie: Codable {
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Double
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String
    let title: String
    let voteAverage: Double
    let voteCount: Int
    
    var posterURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500" + posterPath)
    }
    
    var firstOverviewSentence: String? {
        let sentences = overview.components(separatedBy: ".")
        return sentences.first?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private enum CodingKeys: String, CodingKey {
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
