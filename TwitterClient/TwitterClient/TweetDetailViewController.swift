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
    @IBOutlet weak var tweetUserName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetStatus: UILabel!
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetUserName.text = tweet.user?.name ?? "Unknown"
        tweetText.text = tweet.text
        if tweet.isARetweet { retweetStatus.isHidden = false }
        if let user = tweet.user {
            UIImage.fetchImageWith(user.profileImageURL, callback: { (image) in
                self.userImageView.image = image
            })
        }
    }
    
    
}
