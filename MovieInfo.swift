//
//  MovieInfo.swift
//  MiniProject
//
//  Created by 유민아 on 2023/06/15.
//

import Foundation

struct Cast: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Double
    let profile_path: String?
    let cast_id: Int
    let character: String
    let credit_id: String
    let order: Int
}

struct Crew: Codable {
    let adult: Bool
    let gender: Int
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Double
    let profile_path: String?
    let credit_id: String
    let department: String
    let job: String
}

struct MovieInfo: Codable {
    let id: Int
    let cast: [Cast]
    let crew: [Crew]

    private enum CodingKeys: String, CodingKey {
        case id
        case cast
        case crew
    }
}
