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
    
    func getMovies(page: Int) {
        guard let url = URL(string: getUrl(page: page)) else { return }
        
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
                    // self.performSegue(withIdentifier: "movieIndentifier", sender: self.movies)
                    
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }

    // for refresh
    func getCurrentPage() {
        getMovies(page: currentPage)
    }

    // next page
    func getNextPage() {
        currentPage += 1
        getMovies(page: currentPage)
    }
    
    // format url with page
    func getUrl(page: Int) -> String {
        let query:String = "year=2017&api_key=df1b9abfde892d0d5407d6b602b349f2&page=\(String(page))"
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
