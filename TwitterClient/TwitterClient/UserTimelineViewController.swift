//
//  UserTimelineViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/23/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class UserTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var screenName : String!
    
    var allTweets = [Tweet]() { // reloads tableview once network call to fetch tweets is completed
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // datasource protocol requirements
        // how many rows to display
        // what to display in rows
        
        let tweetNib = UINib(nibName: "TweetNibCell", bundle: nil)
        self.tableView.register(tweetNib, forCellReuseIdentifier: TweetNibCell.identifier)
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension

        API.shared.getTweetsFor(screenName, callback: { (HandlerType) in OperationQueue.main.addOperation {
                switch HandlerType {
                    case .tweetsCallback(let tweets):
                    self.allTweets = tweets ?? []
                    break
                    default:
                    break
                }
            }
        })
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int { return allTweets.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetNibCell.identifier, for: indexPath) as! TweetNibCell
        
        let tweet = self.allTweets[indexPath.row]
        cell.tweet = tweet
        return cell
    }

    func updateTimeline() {
     // this is broken
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
