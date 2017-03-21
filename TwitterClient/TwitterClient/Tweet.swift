//
//  Tweet.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/20/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import Foundation

class Tweet {
    let text : String
    let id : String
    
    var user : User? // Set as an optional because some tweets (most often "sponsored tweets" don't have an associated Twitter user account
    
    init?(json: [String: Any]) { // Failable initializer
        if let text = json["text"] as? String, let id = json["id_str"] as? String { // chain together both optional unwrap
            self.text = text
            self.id = id
            if let userDictionary = json["user"] as? [String: Any]{
                self.user = User(json: userDictionary)
            }
        } else { // if both values cannot be cast as Strings, return a nil value
            return nil
        }
    }
}
