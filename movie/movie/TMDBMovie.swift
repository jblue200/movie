//
//  TMDBMovie.swift
//  movie
//
//  Created by May Shi on 9/7/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import Foundation

class TMDBMovie {
    
    var movies:[Movie]
    var baseUrl:String
    var currentPage:Int
    var totalPage:Int
    
    init() {
        movies = []
        baseUrl = "https://api.themoviedb.org/3/discover/movie"
        currentPage = 0
        totalPage = 0
    }
    
    func getMovies(completion: @escaping (() -> Void)) {
        guard let url = URL(string: getUrl()) else { return }
        
        print(url.absoluteURL)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                //Decode retrived data with JSONDecoder and assing type of Movies object
                let moviesData = try JSONDecoder().decode(Movies.self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.addMovie(movieResult: moviesData.results)
                    completion()
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }

    // next page
    func getNextPage(completion: @escaping (() -> Void)) {
        currentPage += 1
        getPage(completion: completion)
    }
    
    func refreshPage(completion: @escaping (() -> Void)) {
        print("refresh page")
        currentPage = 0
        movies = []
        getPage(completion: completion)
    }

    func getPage(completion: @escaping (() -> Void)) {
        getMovies(completion: completion)
    }
    
    // format url with page
    func getUrl() -> String {
        var query:String = "year=2017&api_key=df1b9abfde892d0d5407d6b602b349f2"
        
        if currentPage > 0 {
            query += "&page=\(String(currentPage))"
        }
        
        return "\(baseUrl)?\(query)"
    }
    
    func addMovie( movieResult: [Movie]) {
        for movie in movieResult {
            if !movie.adult {
                movies.append(movie)
            }
        }
    }
}
