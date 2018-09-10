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
        tmdb.getPage(completion: displayMovie)
    }
    
    func displayMovie() {
        self.performSegue(withIdentifier: "movieIndentifier", sender: tmdb)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieCollectionViewController {
            movieVC.tmdb = sender as! TMDBMovie
        }
    }
}
