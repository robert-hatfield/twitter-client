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
    
    @IBOutlet weak var viewUserButton: UIButton!
    
    var tweet : Tweet!
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let user = tweet.user {
            self.user = user
            screenNameLabel.text = "@\(user.screenName)"
            tweetNameLabel.text = user.name
            UIImage.fetchImageWith(user.profileImageURL, callback: { (image) in
                self.userImageView.image = image
            })
        } else {
            self.user = nil
            screenNameLabel.isHidden = true
            tweetNameLabel.text = "Unknown user"
        }
        
        tweetText.text = tweet.text
        
        if tweet.isARetweet { retweetStatus.isHidden = false }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == UserTimelineViewController.identifier {
            guard let destinationController = segue.destination as? UserTimelineViewController else { return }
            if user != nil {
             destinationController.screenName = tweet.user!.screenName
            } else { return }
        }
    }
}
    

