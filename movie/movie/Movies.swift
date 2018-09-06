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
