//
//  DetailViewController.swift
//  Flicks
//
//  Created by Suyeon Kang on 2/1/16.
//  Copyright © 2016 Suyeon Kang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie:NSDictionary!
    
    override func viewDidLoad() {
     //   print(movie)

        //scrollView.frame;
        super.viewDidLoad()
        self.scrollView.contentSize=CGSize(width:self.scrollView.frame.size.width, height:infoView.frame.origin.y+infoView.frame.size.height)
        
        titleLabel.text = movie["title"] as? String
       overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
        let baseUrl="http://image.tmdb.org/t/p/w342"
        if let posterPath=movie["poster_path"]  as? String{
            let imageUrl=NSURL(string:baseUrl+posterPath)
                self.posterImageView.setImageWithURL(imageUrl!)
//            let imageRequest=NSURLRequest(URL:imageUrl!)
//            posterImageView.setImageWithURLRequest(
//                imageRequest,
//                placeholderImage: nil,
//                success: { (imageRequest, imageResponse, image) -> Void in
//                    
//                    // imageResponse will be nil if the image is cached
//                    if imageResponse != nil {
//                        //   print("Image was NOT cached, fade in image")
//                        cell.posterView.alpha = 0.0
//                        cell.posterView.image = image
//                        UIView.animateWithDuration(0.3, animations: { () -> Void in
//                            cell.posterView.alpha = 1.0
//                        })
//                    } else {
//                        //    print("Image was cached so just update the image")
//                        cell.posterView.image = image
//                    }
//                },
//                failure: { (imageRequest, imageResponse, error) -> Void in
//                    // do something for the failure condition
//            })
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
