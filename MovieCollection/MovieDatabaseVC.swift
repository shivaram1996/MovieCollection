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
        searchBar.showsCancelButton = true
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.movieList = nil
        self.movieCollection.reloadData()
    }
    
}


extension MovieDatabaseVC : UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.Search?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.movieTitle.text = self.movieList?.Search?[indexPath.row].title ?? ""
        if let imgUrl = self.movieList?.Search?[indexPath.row].poster,let keyId = self.movieList?.Search?[indexPath.row].imdbID {
            Utility.getImage(cache: self.imageCache, key: keyId, url: imgUrl, completion: { (image,flag) in
                if let posterImage = image,flag{
                    DispatchQueue.main.async {
                        cell.posterIcon.image = posterImage
                    }
                }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailedVC") as? MovieDetailedVC
        vc?.movieId = self.movieList?.Search?[indexPath.row].imdbID
        vc?.imageCache = imageCache
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    


}

extension MovieDatabaseVC : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 5
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension)
    }
}
