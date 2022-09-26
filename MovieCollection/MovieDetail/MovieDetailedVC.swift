//
//  MovieDetailVC.swift
//  MovieCollection
//
//  Created by shiva ram on 26/09/22.
//
import UIKit

class MovieDetailedVC: UIViewController {
    
    var apiManager : NetworkClient?
    var movieId : String?
    @IBOutlet weak var tableView: UITableView!
    var movieResponse : MovieDetailResponse?
    var imageCache : NSCache<AnyObject, UIImage>?
    //MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiManager = NetworkManager.shared
        // Create the URL to fetch
        var urlString = "https://www.omdbapi.com/?apikey=f149143e"
        urlString += "&i=" + movieId!
        guard let url = URL(string: urlString) else { fatalError("Invalid URL") }
        
        // Request data from the backend
        apiManager?.getRequest(fromURL: url, httpMethod: .get) { (result: Result<MovieDetailResponse, Error>) in
            switch result {
            case .success(let movieResponse):
                DispatchQueue.main.async {[weak self] in
                    self?.movieResponse = movieResponse
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                debugPrint("Unable to load the list: \(error.localizedDescription)")
            }
        }

    }
    
    
  
}


extension MovieDetailedVC : UITableViewDelegate,UITableViewDataSource {
  
     //MARK: Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MovieDetailTableViewCell else {return UITableViewCell()}
        cell.itemTitle.text = movieResponse?.title ?? ""
        cell.itemDirector.text = movieResponse?.directorName ?? ""
        cell.itemRelease.text = movieResponse?.releaseDate ?? ""
        cell.itemPlot.text = movieResponse?.plot ?? ""
        if let imgUrl = movieResponse?.poster,let keyId = movieId {
            Utility.getImage(cache: self.imageCache, key: keyId, url: imgUrl, completion: { (image,flag) in
                if let posterImage = image,flag{
                    DispatchQueue.main.async {
                        cell.actInd.stopAnimating()
                        cell.actInd.isHidden = true
                        cell.itemImage.image = posterImage
                    }
                }
            })
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

