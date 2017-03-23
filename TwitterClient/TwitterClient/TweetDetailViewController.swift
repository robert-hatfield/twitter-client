//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/22/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet var tweetDetailView: TweetDetailView!
    
    var tweet : Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetDetailView.tweetUserName.text = tweet.user?.name ?? "Unknown"
        tweetDetailView.tweetText.text = tweet.text
        if tweet.isARetweet { tweetDetailView.retweetStatus.isHidden = false }
    }


}
