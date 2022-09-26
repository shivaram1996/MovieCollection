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
    var movieList = [MovieResponse]()
    
    var totalPages = 1
    var currentPage = 1
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageCache = NSCache<AnyObject, UIImage>()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        movieCollection.delegate = self
        movieCollection.dataSource = self
    }
    
    func fetchMovieList(text: String,page : Int){
        apiManager = NetworkManager.shared
        // Create the URL to fetch
        var urlString = "https://www.omdbapi.com/?apikey=f149143e"
        urlString += "&s=" + text.trimmingCharacters(in: .whitespacesAndNewlines)
        urlString += "&page=" + "\(page)"
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        
        // Request data from the backend
        apiManager?.getRequest(fromURL: url, httpMethod: .get) { (result: Result<MovieList, Error>) in
            switch result {
            case .success(let movieResponse):
                DispatchQueue.main.async {[weak self] in
                    print("Current page",self?.currentPage)
                    if let list = movieResponse.Search{
                        self?.movieList.append(contentsOf: list)
                    }
                    
                    self?.totalPages = (Int(movieResponse.totalResults ?? "") ?? 0)/10
                    self?.movieCollection.reloadData()
                }
            case .failure(let error):
                debugPrint("Unable to load the list: \(error.localizedDescription)")
            }
        }
    }

    

}


extension MovieDatabaseVC : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            searchText = text
            fetchMovieList(text : searchText,page: currentPage)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        searchBar.text = ""
        self.currentPage = 1
        self.totalPages = 1
        self.movieList.removeAll()
        self.movieCollection.reloadData()
    }
    
}


extension MovieDatabaseVC : UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.movieTitle.text = self.movieList[indexPath.row].title ?? ""
        if let imgUrl = self.movieList[indexPath.row].poster,let keyId = self.movieList[indexPath.row].imdbID {
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.row == movieList.count - 1{
            currentPage = currentPage + 1
            fetchMovieList(text: searchText, page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MovieDetailedVC") as? MovieDetailedVC
        vc?.movieId = self.movieList[indexPath.row].imdbID
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
