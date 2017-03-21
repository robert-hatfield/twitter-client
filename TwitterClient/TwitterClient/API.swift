//
//  API.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/21/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import Foundation
import Accounts
import Social

typealias AccountCallback = (ACAccount?) -> ()
typealias UserCallback = (User?) -> ()
typealias TweetsCallback = ([Tweet]?) -> ()

class API {
    static let shared = API() // instantiate a singleton instance of this class
    
    var account : ACAccount?
    
    // Get Twitter account from device, using the Accounts Framework
    private func login(callback: @escaping AccountCallback) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                callback(nil)
                return
            }
            
            if success {
                if let account = accountStore.accounts(with: accountType).first as? ACAccount {
                    callback(account)
                }
            } else {
                print("The user did not allow access to their account.")
                callback(nil)
            }
        }
    }
    
    // Get OAuth user using Social Framework - validating with Twitter
    private func getOAuthUser(callback: @escaping UserCallback) {
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: { (data, response, error) in
                if let error = error {
                    print ("Error: \(error.localizedDescription)")
                    callback(nil)
                    return
                }
                
                guard let response = response else { callback(nil); return }
                guard let data = data else { callback(nil); return }
                
                switch response.statusCode {
                case 200...299:
                    // danger zone below - to be refactored in lab assignment
                    if let userJSON = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        let user = User(json: userJSON)
                        callback(user)
                    }default:
                    print("Error: response came back with statusCode: \(response.statusCode)")
                    callback(nil)
                }
            })
        }
        
        
    }
    
    // Post to timeline
    private func updateTimeline(callback: @escaping TweetsCallback) {
        
    }
    
    // Get tweets - this public method will provide access to the private methods above
    func getTweets(callback: TweetsCallback) {
        
    }
    
}
