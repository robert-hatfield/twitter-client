//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/22/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet : Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        if tweet.isARetweet{ print("RETWEET" ) }
        print(self.tweet.user?.name ?? "Unknown")
        print(self.tweet.text)
        
    }


}
