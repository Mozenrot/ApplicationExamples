//
//  AllMoviesViewController.swift
//  MovieAppInManageTask
//
//  Created by LeoChernyak on 26/07/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import SwiftyJSON

class AllMoviesViewController: UITableViewController, UISearchResultsUpdating {
    
    
    
    //Variables
    
    let URL_MOVIES_LIST = "http://x-mode.co.il/exam/allMovies/allMovies.txt"
    let URL_MOVIE_DESCRIPTION = "http://x-mode.co.il/exam/descriptionMovies/"
    
    var movieList : [Movie] = []
    var filteredMovieList = [Movie]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMovieList(sourceUrl: URL_MOVIES_LIST)
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        tableView.reloadData()
    }
    
    
    // MARK: - Parsing movieFile
    func getMovieList(sourceUrl: String) {
        if let url = URL(string: sourceUrl) {
            do {
                let contents = try String(contentsOf: url)
                if let data = contents.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        for item in json["movies"].arrayValue {
                            var object = Movie()
                            object.id = item["id"].stringValue
                            object.name = item["name"].stringValue
                            object.category = item["category"].stringValue
                            object.year = item["year"].stringValue
                            movieList.append(getMovieDescription(sourceUrl: URL_MOVIE_DESCRIPTION, movieId: object.id!, movieObject: object))
                        }
                    }
                }
            } catch {
                print(error)
            }
        } else {
           print("URL is Bad")
        }
    }
    
    
    func getMovieDescription(sourceUrl: String, movieId: String, movieObject: Movie) -> Movie {
        
        var movieObjectWithDescription = movieObject
        if let url = URL(string: "\(sourceUrl)\(movieId).txt") {
            do {
                let contents = try String(contentsOf: url)
                if let data = contents.data(using: .utf8) {
                    if let json = try? JSON(data: data) {
                        movieObjectWithDescription.movieDescription = json["description"].stringValue
                        let imageUrl = json["imageUrl"].stringValue
                        print(imageUrl)
                        if let url = URL(string: imageUrl) {
                            do {
                                movieObjectWithDescription.imageData = try Data(contentsOf: url)
                            } catch {
                                print(error)
                            }
                        }
                        //There is problem with image url on a gladiator movie
                        if imageUrl == "\(sourceUrl)1009.jpg" {
                            let image = UIImage(named: "poster_none.png")
                            let data = image?.pngData()
                            movieObjectWithDescription.imageData = data
                        }
                    }
                }
            } catch {
                print(error)
            }
        } else {
            print("URL is Bad")
        }
        
        return movieObjectWithDescription
        
    }
    
    
    
    
    
    
    
    
    // MARK: - SearchBar source
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredMovieList.removeAll(keepingCapacity: false)
        
        let searchTerm = searchController.searchBar.text!
        let array = movieList.filter { movie in
            return movie.name!.contains(searchTerm)
        }
        filteredMovieList = array
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MovieCell
        
        if (resultSearchController.isActive) {
            cell.movieNameLabel.text = filteredMovieList[indexPath.row].name
            cell.movieCategoryLabel.text = filteredMovieList[indexPath.row].category?.capitalized
            cell.movieYearLabel.text = filteredMovieList[indexPath.row].year
            cell.posterImage.image = UIImage(data: filteredMovieList[indexPath.row].imageData!)
            return cell
        }
        else {
            
            //filterd by year
            movieList = movieList.sorted(by: {
                guard let first: String = ($0 as Movie).year else { return false }
                guard let second: String = ($1 as Movie).year else { return true }
                return first > second
            })
            
            
            cell.movieNameLabel.text = movieList[indexPath.row].name
            cell.movieCategoryLabel.text = movieList[indexPath.row].category?.capitalized
            cell.movieYearLabel.text = movieList[indexPath.row].year
            cell.posterImage.image = UIImage(data: movieList[indexPath.row].imageData!)
           
            return cell
        }
    
    }

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if  (resultSearchController.isActive) {
            return filteredMovieList.count
        } else {
            return movieList.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMovie", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MovieDescriptionViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.movieDescription = movieList[indexPath.row].movieDescription
            destinationVC.imageViewData = movieList[indexPath.row].imageData
            destinationVC.movieName = movieList[indexPath.row].name
        }
    }
    

}
