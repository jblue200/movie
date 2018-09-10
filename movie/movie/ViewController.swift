//
//  ViewController.swift
//  movie
//
//  Created by May Shi on 9/6/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tmdb: TMDBMovie = TMDBMovie()
    var networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkManager.isConnected() {
            tmdb.getPage(completion: displayMovie)
        }
        else {
           displayConnectivity()
        }
    }
    
    func displayMovie() {
        self.performSegue(withIdentifier: "movieIndentifier", sender: tmdb)
    }
    
    func displayConnectivity() {
        self.performSegue(withIdentifier: "loadingToConnectivity", sender: tmdb)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieVC = segue.destination as? MovieCollectionViewController {
            movieVC.tmdb = sender as! TMDBMovie
        }
        
        if let connectivityVC = segue.destination as? ConnectivityViewController {
            print("connectivityVC")
            connectivityVC.tmdb = sender as! TMDBMovie
        }
    }
}
