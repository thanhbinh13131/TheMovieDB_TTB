//
//  MovieDBViewController.swift
//  TheMovieDB_Demo_TTB
//
//  Created by TTB on 5/20/17.
//  Copyright © 2017 TTB. All rights reserved.
//

import UIKit

class MovieDBViewController: UITableViewController {
    var queue = OperationQueue()
    var urlImage: String = "https://image.tmdb.org/t/p/w320"
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var loadingData = false
    
    var movies = [Movie]()
    
    
    class Downloader {
        class func downloadImageWithURL(_ url:String) -> UIImage!{
            
            let data = try? Data(contentsOf: URL(string: url)!)
            return UIImage(data: data!)
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMovie()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie.getTitle()
        let overview = movie.getOverview()
        
        queue = OperationQueue()
        let operation = BlockOperation(block: {
            let image = Downloader.downloadImageWithURL("\(self.urlImage)\(movie.getPosterPath())")
            OperationQueue.main.addOperation(
                {
                    cell.movieImage?.image = image
                }
            )
            
        })
        queue.addOperation(operation)
        print("\(self.urlImage)\(String(describing: movie.getPosterPath()))")
        
        
        cell.movieTitle?.text = title
        cell.movieOverview?.text = overview
        print(indexPath.row)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indentifier = segue.identifier {
            switch indentifier {
            case "DetailMovie":
                let movieDetailVC = segue.destination as! DetailViewController
                if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                    movieDetailVC.movie = movieAtIndexPath(indexPath: indexPath as NSIndexPath)
                }
            default:
                break
            }
        }
    }
    
    func movieAtIndexPath(indexPath: NSIndexPath) -> Movie{
        let movie = movies[indexPath.row]
        return movie
        
    }
    
    
    func fetchMovie() {
        let apiKey = "8656e08895888abef3fe1c0b123362b0"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
         var request = URLRequest(url: url!)
              request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler:{
                (dataOrNil, response, error) in if let data = dataOrNil{
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                    with: data, options:[]) as? [String:AnyObject]{
                        
                      //  print("response: \(responseDictionary)")
                        if let arrayMovies:AnyObject = responseDictionary["results"]{
                            for movieItemString in (arrayMovies as? [AnyObject])!{
                                if let movieItemString = movieItemString as? [String:AnyObject] {
                                    let title = movieItemString["title"] as? String
                                   // print("title: \(String(describing: title)) \n")
                                    let overview = movieItemString["overview"] as? String
                                    //print("overview: \(String(describing: overview)) \n")
                                    let posterPath = movieItemString["poster_path"] as? String
                                    //print("poster: \(String(describing: posterPath)) \n")
                                    let dateRelease = movieItemString["release_date"] as? String
                                    
                                    self.movies.append(Movie(title: title!, overview: overview!, dateRelease: dateRelease!, posterPath: posterPath!))
                                }
                            }
                        
                        }
                        
                        
                        //self.movies = responseDictionary["results"] as? [Movie]
                        self.tableView.reloadData()
                    }
                    else{
                        print("khong co du lieu")
                    }
                }
                else {
                    print("khong co du lieu duoi")
            }
                
        })
        task.resume()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
