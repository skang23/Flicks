//
//  CollectionViewController.swift
//  Flicks
//
//  Created by Suyeon Kang on 1/25/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class CollectionViewController: UIViewController,UICollectionViewDataSource, UISearchBarDelegate  {
    var movies:[NSDictionary]?
    var selectedRow = -1;
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var networkError: UILabel!
 //   @IBOutlet weak var searchBar: UISearchBar!

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
                           // print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            self.collectionView.reloadData()
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
                        //    print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            
                            self.collectionView.reloadData()
                            
                            refreshControl.endRefreshing()
                            
                    }
                }
        })
        task.resume()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedRow = -1
        collectionView.dataSource=self;
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
//        searchBar.delegate=self;

        loadDataFromNetwork();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies=movies {
            return movies.count;
        }else{
            return 0;
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionViewCell
        let movie=movies![indexPath.row]
        let title=movie["title"] as! String
        let overview=movie["overview"] as! String
        let baseUrl="http://image.tmdb.org/t/p/w342"
        let posterPath=movie["poster_path"] as! String
        let imageUrl=NSURL(string:baseUrl+posterPath)
        // cell.posterView.setImageWithURL(imageUrl!);
        let imageRequest=NSURLRequest(URL:imageUrl!)
        let gesture = UITapGestureRecognizer(target: self, action: "showDetail:")
        cell.addGestureRecognizer(gesture)
        cell.posterView.setImageWithURLRequest(
            imageRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                  //  print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                  //  print("Image was cached so just update the image")
                    cell.posterView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        cell.tag=indexPath.row
        
        //! -> positive that it is not nil
        //only cells that are on the screen
        // cell.textLabel!.text=title
       // cell.titleLabel.text=title
       // cell.overview.text=overview
        
        return cell

    }
    func showDetail(sender:UITapGestureRecognizer){
        print("abc")
        print(sender)
        let cell=sender.view as! CollectionViewCell
        self.selectedRow = cell.tag
        print("cell.tag\(self.selectedRow)")

        self.performSegueWithIdentifier("toMovieView", sender: nil)
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "toMovieView") {
            let detailVC = segue.destinationViewController as! MoviewViewController;
            
           // let cell=sender.view as! CollectionViewCell
            //detailVC.selectedRow=cell.tag
            detailVC.selectedRow = self.selectedRow
            print(detailVC.selectedRow)
        }
        
    }// end prepareForSegue
   


}
