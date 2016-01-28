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

class MoviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var filteredData: [NSDictionary]?

 
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var networkError: UILabel!
    var movies:[NSDictionary]?
    var selectedRow = -1
    @IBAction func touchDown(sender: AnyObject) {
        touchButton.imageView!.image=UIImage(named: "blue");
    }
    var selectedIndexPath: NSIndexPath? = nil
    var selectedCell:MovieCell?=nil
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("select")
        endEditing()
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! MovieCell
        selectedCell=cell
        switch selectedIndexPath {
        case nil:
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath! == indexPath {
                selectedIndexPath = nil
            } else {
                selectedIndexPath = indexPath
            }
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        let smallHeight: CGFloat = 128.0
       // let expandedHeight: CGFloat = 200.0
        let expandedHeight: CGFloat=200.0
       // CGFloat = cell.overview.frame.height

        let ip = indexPath
        if selectedIndexPath != nil {

            if ip == selectedIndexPath! {
                let height=selectedCell!.overview.frame.height+selectedCell!.titleLabel.frame.height+10
                let posterHeight=selectedCell!.posterView.frame.height
                return height>posterHeight ? height : posterHeight
              //  return smallHeight
                
              //  return cell.overview.frame.height
               // return expandedHeight
            } else {
                return smallHeight
            }
        } else {
            return smallHeight
        }
    }
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
                       //     print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            self.filteredData=self.movies;
                            self.tableView.reloadData()
                            if self.selectedRow != -1
                            {
                                print("scroll")
                                let indexPath = NSIndexPath(forRow: self.selectedRow, inSection: 0)
                                self.tableView.scrollToRowAtIndexPath(indexPath,
                                    atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                            }
                    }
                }
        })
        task.resume()
        
        

      
    }
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
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
                         //   print("response: \(responseDictionary)")
                            self.movies=responseDictionary["results"] as! [NSDictionary]
                            self.filteredData=self.movies;

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
        searchBar.delegate=self;
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource=self;
        tableView.delegate=self;
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
       
        
    }
    func endEditing(){
        self.searchBar.endEditing(true);}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies=filteredData {
            return movies.count;
        }else{
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell=tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie=filteredData![indexPath.row]
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
                 //   print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = image
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    })
                } else {
                //    print("Image was cached so just update the image")
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
        
//        let maxHeight : CGFloat = 10000
//        let rect = cell.attributedText?.boundingRectWithSize(CGSizeMake(maxWidth, maxHeight),
//            options: .UsesLineFragmentOrigin, context: nil)
//        var frame = label.frame
//        frame.size.height = rect.size.height
//        label.frame = frame
//        CGSize size = cell.sizeThatFits(CGSizeMake(label.frame.size.width, CGFLOAT_MAX))
//        CGRect frame = cell.frame;
//        frame.size.height = size.height;
//        cell.frame = frame;
        if cell.overview.text != nil {
        let height=heightForView(cell.overview.text!, font: cell.overview.font, width: cell.overview.frame.width)
        cell.overview.frame.size=CGSizeMake(cell.overview.frame.width, height)
        }
        //cell.overview.frame.height=heightForView(cell.overview.text, font: cell.overview.font, width: cell.overview.frame.width)
        //cell.overview.size
       // print ("row \(indexPath.row)")
        return cell
    }
    
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    //    NSLog("searchBar")
        // When there is no text, filteredData is the same as the original data
        if searchText.isEmpty {
            filteredData = movies
        } else {
            // The user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
           // NSLog("searchBar1")
            filteredData = movies!.filter({(dataItem: NSDictionary) -> Bool in
                // If dataItem matches the searchText, return true to include it
                let str:String=dataItem["title"] as! String
                if str.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
          
        }
        tableView.reloadData()
    }
 
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true);
    }
    
 

}
