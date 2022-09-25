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

extension MovieDetailedVC : UITableViewDelegate,UITableViewDataSource{
    //MARK: Table View Data Source
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
       return (self.selectedItem.count)
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return self.sectionNames[section]
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemDetailsTableViewCell
       cell.itemType.text = selectedItem[indexPath.section].objectSummary.type
       cell.itemName.text = selectedItem[indexPath.section].objectSummary.name
       DispatchQueue.main.async {
           if let imgUrl = self.selectedItem[indexPath.section].image?.url {
                   cell.actInd.startAnimating()
               Helper.getImage(key: self.sectionNames[indexPath.section], url: imgUrl, tableView: self.tableView, completion: { (image) in
                       if (image != nil) {
                           cell.itemImage.image = image
                           cell.actInd.stopAnimating()
                           cell.actInd.isHidden = true
                       }
          
                   })
           }
           else
           {
              cell.itemImage.isHidden = true
              cell.actInd.isHidden =   true
           }
       }
       var description = selectedItem[indexPath.section].objectSummary.description
       cell.itemDesc.text = description
       return cell
   }
   
   
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   
}
