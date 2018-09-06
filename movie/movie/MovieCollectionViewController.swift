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
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // self.clearsSelectionOnViewWillAppear = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.setItemWidth(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        clearSubview(subviews: cell.contentView.subviews) // clear subviews
        
        let movie = movies[indexPath.item]
        
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor.gray
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        // add poster
        let poster:UIImageView = getImage(posterPath: movie.poster_path)
        cell.contentView.addSubview(poster)
        
        // add label
        let detail:UILabel = createDetail(title: movie.title, rating: movie.vote_average, releaseDate: movie.release_date)
        cell.contentView.addSubview(detail)
        cell.contentView.tag = indexPath.item
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewDidLayoutSubviews()
        self.collectionViewLayout.invalidateLayout()
        self.collectionView!.reloadData()
    }
    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func clearSubview(subviews: [UIView]) {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    func createDetail(title: String, rating: Float, releaseDate: String) -> UILabel {
        let label:UILabel = UILabel(frame: CGRect(x:10, y: 107, width: getWidth() - 20, height:20))
        label.text = title + " " + releaseDate + " (" + String(rating) + ")"
        label.textColor = UIColor.darkText
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func getImage(posterPath: String) -> UIImageView {
        let imageUrlString = "https://image.tmdb.org/t/p/w154" + posterPath
        let imageUrl:URL = URL(string: imageUrlString)!
        let imageData:NSData = NSData(contentsOf: imageUrl)!
        let imageView = UIImageView(frame: CGRect(x:0, y:5, width:getWidth(), height:100))

        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                imageView.image = image
                imageView.contentMode = UIViewContentMode.scaleAspectFit
            }
        }
        return imageView
    }
    
    @objc func setItemWidth(_ sender: Any) {
        layout.itemSize = CGSize(width: getWidth(), height: 130)
    }
}
