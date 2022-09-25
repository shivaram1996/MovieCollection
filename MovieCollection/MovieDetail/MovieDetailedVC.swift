//
//  MovieDetailVC.swift
//  MovieCollection
//
//  Created by shiva ram on 26/09/22.
//
import UIKit

class MovieDetailedVC: UIViewController {
    
    var apiManager : NetworkClient?
   // @IBOutlet weak var tableView: UITableView!

    //MARK: Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiManager = NetworkManager.shared
        // Create the URL to fetch
        guard let url = URL(string: "https://www.omdbapi.com/?apikey=f149143e&i=tt0372784") else { fatalError("Invalid URL") }

        // Request data from the backend
        apiManager?.getRequest(fromURL: url, httpMethod: .get) { (result: Result<MovieList, Error>) in
            switch result {
            case .success(let movieList):
                debugPrint("We got a successful result with \(movieList.Search?.count) movies.")
            case .failure(let error):
                debugPrint("We got a failure trying to get the users. The error we got was: \(error.localizedDescription)")
            }
         }

    }
    
    
  
}
