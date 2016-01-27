//
//  MoviewViewController.swift
//  Flicks
//
//  Created by Suyeon Kang on 1/25/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviewViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var networkError: UILabel!
    var movies:[NSDictionary]?
    
    func loadDataFromNetwork() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let err = error{
                    self.networkError.hidden=false;
                    print(error?.description)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
                else{
                    self.networkError.hidden=true;
                }
                if let data = dataOrNil {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)

                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
                }
        })
        task.resume()

      
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let err = error{
                    self.networkError.hidden=false;
                    print(error?.description)
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    refreshControl.endRefreshing()
                }
                else{
                    self.networkError.hidden=true;
                }
                if let data = dataOrNil {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            
                            refreshControl.endRefreshing()

                    }
                }
        })
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromNetwork()

        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource=self;
        tableView.delegate=self;
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies=movies {
            return movies.count;
        }else{
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie=movies![indexPath.row]
        let title=movie["title"] as! String
        let overview=movie["overview"] as! String
        let baseUrl="http://image.tmdb.org/t/p/w342"
        let posterPath=movie["poster_path"] as! String
        let imageUrl=NSURL(string:baseUrl+posterPath)
       // cell.posterView.setImageWithURL(imageUrl!);
        let imageRequest=NSURLRequest(URL:imageUrl!)
        cell.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        
        //! -> positive that it is not nil
        //only cells that are on the screen
       // cell.textLabel!.text=title
        cell.titleLabel.text=title
        cell.overview.text=overview
        
        print ("row \(indexPath.row)")
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
