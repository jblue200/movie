//
//  DetailViewController.swift
//  movie
//
//  Created by May Shi on 9/11/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var movie: Movie!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayText()
        displayImage()
    }
    
    func displayText() {
        print(movie.backdrop_path)
        name.text = movie.title
        year.text = movie.release_date
        rating.text = "rating: \(String(movie.vote_average))"
        detail.text = movie.overview
    }

    func displayImage() {
        let imageUrlString = "https://image.tmdb.org/t/p/w154" + movie.backdrop_path // .poster_path
        let imageUrl:URL = URL(string: imageUrlString)!
        
        if let imageData:NSData = NSData(contentsOf: imageUrl) {
            // Start background thread so that image loading does not make app unresponsive
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData as Data)
                    self.poster.image = image
                    self.poster.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
        }
    }

}
