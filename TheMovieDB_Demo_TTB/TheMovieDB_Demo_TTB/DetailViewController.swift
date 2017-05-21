//
//  DetailViewController.swift
//  TheMovieDB_Demo_TTB
//
//  Created by TTB on 5/20/17.
//  Copyright © 2017 TTB. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var queue = OperationQueue()

    @IBOutlet weak var movieDetailTitle: UILabel!
    
    
    @IBOutlet weak var movieDetailDateRelease: UILabel!
    
    @IBOutlet weak var movieDetailImage: UIImageView!
    
    @IBOutlet weak var movieDetailOverview: UILabel!
    
    var urlImage: String = "https://image.tmdb.org/t/p/w320"
    var movie: Movie?
    
    class Downloader {
        class func downloadImageWithURL(_ url:String) -> UIImage!{
            
            let data = try? Data(contentsOf: URL(string: url)!)
            return UIImage(data: data!)
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        movieDetailTitle.text = movie?.getTitle()
        movieDetailOverview.text = movie?.getOverview()
        movieDetailDateRelease.text = movie?.getDateRelease()
        
        queue = OperationQueue()
        let operation = BlockOperation(block: {
            let image = Downloader.downloadImageWithURL("\(self.urlImage)\(self.movie?.getPosterPath() ?? "https://image.tmdb.org/t/p/w320/")")
            OperationQueue.main.addOperation(
                {
                    self.movieDetailImage.image  = image
                }
            )
            
        })
        queue.addOperation(operation)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
