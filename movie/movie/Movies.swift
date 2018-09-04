//
//  Movies.swift
//  movie
//
//  Created by May Shi on 9/4/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import Foundation

struct Movies: Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct Movie: Decodable {
    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Float
    let title: String
    let popularity: Double
    let poster_path: String
    let original_language: String
    let original_title: String
    let genre_ids: [Int]!
    let backdrop_path: String
    let adult: Bool
    let overview: String
    let release_date: String
}
