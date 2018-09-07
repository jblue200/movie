//
//  ViewController.swift
//  movie
//
//  Created by May Shi on 9/6/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tmdb:TMDBMovie = TMDBMovie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? tmdb.getCurrentPage()
        self.performSegue(withIdentifier: "movieIndentifier", sender: tmdb.movies)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieCollectionViewController {
            movieVC.movies = sender as! [Movie]
        }
    }
}
