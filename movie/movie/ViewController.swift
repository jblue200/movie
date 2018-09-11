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
    var networkManager: NetworkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if networkManager.isConnected() {
            tmdb.getPage(completion: displayMovie)
        }
        else {
           displayConnectivity()
        }
    }
    
    func displayMovie() {
        self.performSegue(withIdentifier: "movieIndentifier", sender: self)
    }
    
    func displayConnectivity() {
        self.performSegue(withIdentifier: "loadingToConnectivity", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectivityVC = segue.destination as? ConnectivityViewController {
            connectivityVC.networkManager = self.networkManager
        }
        
        if let movieVC = segue.destination as? MovieCollectionViewController {
            movieVC.tmdb = self.tmdb
            movieVC.networkManager = self.networkManager
        }
    }
}
