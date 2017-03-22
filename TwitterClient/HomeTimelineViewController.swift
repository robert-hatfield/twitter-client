//
//  HomeTimelineViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/20/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var allTweets = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        updateTimeline()
    }
    
    func updateTimeline() {
        
        self.activityIndicator.startAnimating()
        
        API.shared.getTweets { (HandlerType) in
            OperationQueue.main.addOperation {
                switch HandlerType {
                case .tweetsCallback(let tweets):
                    self.allTweets = tweets ?? [] // nil coalescing
                    self.activityIndicator.stopAnimating()
                    break
                default:
                    self.activityIndicator.stopAnimating()
                    break
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let cell = cell as? TweetCell {
            cell.tweetText.text = allTweets[indexPath.row].text
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
