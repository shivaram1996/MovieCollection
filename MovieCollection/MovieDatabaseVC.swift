//
//  ViewController.swift
//  MovieCollection
//
//  Created by shiva ram on 25/09/22.
//

import UIKit

class MovieDatabaseVC: UIViewController {
    
    
    var apiManager : NetworkClient?
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var imageCache : NSCache<AnyObject, UIImage>?
    var movieList : MovieList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCache = NSCache<AnyObject, UIImage>()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        movieCollection.delegate = self
        movieCollection.dataSource = self
    }

    

}


extension MovieDatabaseVC : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            apiManager = NetworkManager.shared
            // Create the URL to fetch
            var urlString = "https://www.omdbapi.com/?apikey=f149143e"
            urlString += "&s=" + text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
            
            // Request data from the backend
            apiManager?.getRequest(fromURL: url, httpMethod: .get) { (result: Result<MovieList, Error>) in
                switch result {
                case .success(let movieResponse):
                    DispatchQueue.main.async {[weak self] in
                        self?.movieList = movieResponse
                        self?.movieCollection.reloadData()
                    }
                case .failure(let error):
                    debugPrint("Unable to load the list: \(error.localizedDescription)")
                }
            }
        }
    }
    
}


extension MovieDatabaseVC : UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? MovieCell
        cell?.movieTitle.text = self.movieList?.Search?[indexPath.row].title ?? ""
        DispatchQueue.main.async {
            if let imgUrl = self.movieList?.Search?[indexPath.row].poster,let keyId = self.movieList?.Search?[indexPath.row].imdbID {
                Utility.getImage(cache: self.imageCache, key: keyId, url: imgUrl, completion: { (image) in
                    if let posterImage = image{
                        cell?.posterIcon.image = posterImage
                    }
                })
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TODO")
    }
    


}