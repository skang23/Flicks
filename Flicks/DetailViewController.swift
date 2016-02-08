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
        self.infoView.center.x = -self.scrollView.frame.size.width
        self.infoView.center.y = self.view.center.y/2
         self.scrollView.contentSize=CGSize(width:self.scrollView.frame.size.width, height:self.posterImageView.frame.size.height)
        self.view.backgroundColor = UIColor.blackColor()
        titleLabel.text = movie["title"] as? String
       overviewLabel.text = movie["overview"] as? String
        overviewLabel.sizeToFit()
       // CGSize size1 = CGSizeMake(titleLabel.text.frame.width+overviewLabel.frame.width, titleLabel.text.frame.height+overviewLabel.frame.height)
        infoView.sizeThatFits( CGSizeMake(titleLabel.frame.width+overviewLabel.frame.width, titleLabel.frame.height+overviewLabel.frame.height+60))
        let baseUrl="http://image.tmdb.org/t/p/w342"
        if let posterPath=movie["poster_path"]  as? String{
            let imageUrl=NSURL(string:baseUrl+posterPath)
                self.posterImageView.setImageWithURL(imageUrl!)
            self.posterImageView.sizeThatFits(CGSizeMake(self.posterImageView.frame.width, self.posterImageView.frame.height))
            
            var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
            swipeRight.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(swipeRight)
            
            var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
            swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
            self.view.addGestureRecognizer(swipeLeft)
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
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                UIView.animateWithDuration(0.5, animations: {
                    self.infoView.center.x = self.view.center.x
                })
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
                UIView.animateWithDuration(0.5, animations: {
                    self.infoView.center.x = -self.view.center.x
                })
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    @IBAction func scrollOverview(sender: AnyObject) {
        print("pan!")
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
