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
    
    var allTweets = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        updateTimeline()
    }
    
    func updateTimeline() {
        API.shared.getTweets { (HandlerType) in
            OperationQueue.main.addOperation {
                switch HandlerType {
                case .tweetsCallback(let tweets):
                    self.allTweets = tweets ?? [] // nil coalescing
                    break
                default:
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
        let currentTweet = allTweets[indexPath.row]
        cell.textLabel?.text = currentTweet.text
        cell.detailTextLabel?.text = currentTweet.user?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
