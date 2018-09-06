//
//  ViewController.swift
//  movie
//
//  Created by May Shi on 9/6/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movies:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovies()
    }
    
    func getMovies() {
        let urlString = "https://api.themoviedb.org/3/discover/movie?year=2017&api_key=df1b9abfde892d0d5407d6b602b349f2"
        guard let url = URL(string: urlString) else { return }
        
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
                    print("async")
                    self.filterMovie(movieResult: moviesData.results)
                    self.performSegue(withIdentifier: "movieIndentifier", sender: self.movies)
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func filterMovie(movieResult: [Movie]) {
        for movie in movieResult {
            if !movie.adult {
                movies.append(movie)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieCollectionViewController {
            movieVC.movies = sender as! [Movie]
        }
    }
}
