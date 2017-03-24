//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/22/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetNameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetStatus: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = tweet.user {
            screenNameLabel.text = "@\(user.screenName)"
            tweetNameLabel.text = user.name
            UIImage.fetchImageWith(user.profileImageURL, callback: { (image) in
                self.userImageView.image = image
            })
        } else {
            screenNameLabel.isHidden = true
            tweetNameLabel.text = "Unknown user"
        }
        
        tweetText.text = tweet.text
        
        if tweet.isARetweet { retweetStatus.isHidden = false }
        
    }
    
}
