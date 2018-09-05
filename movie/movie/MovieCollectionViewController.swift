//
//  MovieCollectionViewController.swift
//  movie
//
//  Created by May Shi on 9/4/18.
//  Copyright © 2018 May Shi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieCell"

class MovieCollectionViewController: UICollectionViewController {
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // retrieveMovies
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
                    self.movies = self.filterMovie(movieResult: moviesData.results)
                    self.collectionView?.reloadData()
                }
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func filterMovie(movieResult: [Movie]) -> [Movie] {
        var movies: [Movie] = []
        for movie in movieResult {
            if !movie.adult {
                movies.append(movie)
            }
        }
        return movies
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        clearSubview(subviews: cell.contentView.subviews) // clear subviews
        
        let movie = movies[indexPath.item]
        let width:CGFloat = getWidth()
        
        print(width)
        
        cell.backgroundColor = UIColor.gray
        
        // add poster
        let poster:UIImageView = getImage(width: width, posterPath: movie.poster_path)
        cell.contentView.addSubview(poster)
        
        // add label
        let detail:UILabel = createDetail(width: width, title: movie.title, rating: movie.vote_average, releaseDate: movie.release_date)
        cell.contentView.addSubview(detail)
        cell.contentView.tag = indexPath.item
        
        return cell
    }
    
    func getWidth() -> CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return UIScreen.main.bounds.height
        }
        
        return UIScreen.main.bounds.width
    }
    
    func clearSubview(subviews: [UIView]) {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func createDetail(width: CGFloat, title: String, rating: Float, releaseDate: String) -> UILabel {
        let label:UILabel = UILabel(frame: CGRect(x:10, y: 107, width: width, height:20))
        label.text = title + " " + releaseDate + " (" + String(rating) + ")"
        label.textColor = UIColor.darkText
        label.textAlignment = NSTextAlignment.left
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
    func getImage(width: CGFloat, posterPath: String) -> UIImageView {
        let imageUrlString = "https://image.tmdb.org/t/p/w154" + posterPath
        let imageUrl:URL = URL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        let imageView = UIImageView(frame: CGRect(x:10, y:5, width: width, height:100))

        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                imageView.contentMode = UIViewContentMode.scaleAspectFit
            }
        }
        
        return imageView
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("view will transition")
        super.viewDidLayoutSubviews()
        self.collectionViewLayout.invalidateLayout()
        // self.collectionView!.reloadData()
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
