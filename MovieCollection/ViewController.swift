//
//  ViewController.swift
//  MovieCollection
//
//  Created by shiva ram on 25/09/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    var apiManager : NetworkClient?
    
    let imageCache = NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        apiManager = NetworkManager.shared
        // Create the URL to fetch
        guard let url = URL(string: "https://www.omdbapi.com/?s=Batman&apikey=f149143e") else { fatalError("Invalid URL") }

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

