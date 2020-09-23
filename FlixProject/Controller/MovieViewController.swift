//
//  MovieViewController.swift
//  FlixProject
//
//  Created by Elena on 9/22/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String: Any]]() //this is an array of dictionaries

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
            if let error = error {
              print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                //Movies are store in this "self.movies" varaiable.
                //We add "self" bc we're inside a closure
                self.movies = dataDictionary["results"] as! [[String: Any]] //'as!' we're casting
                self.tableView.reloadData()
                //print(dataDictionary)
           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["overview"] as? String
        
        //To download an image using Alamofire cocoapods
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterURL = URL(string: baseURL + posterPath)
        cell.posterView.af.setImage(withURL: posterURL!)

        return cell
    }
}
