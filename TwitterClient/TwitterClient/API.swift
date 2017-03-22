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

//enum Handler {
//    case accountCallback((ACAccount?) -> ())
//    case userCallback((User?) ->())
//    case tweetsCallback(([Tweet]?) -> ())
//}

enum HandlerType {
    case accountCallback(ACAccount?)
    case userCallback(User?)
    case tweetsCallback([Tweet]?)
    case oneTweetCallback(Tweet?)
}

typealias CompletionHandlerType = (HandlerType) -> ()


//typealias accCallback = CompletionHandler.Type.accountCallback?
//typealias UserCallback = (User?) -> ()
//typealias TweetsCallback = ([Tweet]?) -> ()

class API {
    static let shared = API() // instantiate a singleton instance of this class
    
    var account : ACAccount?
    
    // Get Twitter account from device, using the Accounts Framework
    private func login(callback: @escaping CompletionHandlerType) {
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                callback(HandlerType.accountCallback(nil))
                return
            }
            
            if success {
                if let account = accountStore.accounts(with: accountType).first as? ACAccount {
                    callback(HandlerType.accountCallback(account))
                }
            } else {
                print("The user did not allow access to their account.")
                callback(HandlerType.accountCallback(nil))
            }
        }
    }
    
    // Get Twitter account with the OAuth - validating with Twitter
    private func getOAuthUser(callback: @escaping CompletionHandlerType) {
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: { (data, response, error) in
                if let error = error {
                    print ("Error: \(error.localizedDescription)")
                    callback(HandlerType.userCallback(nil))
                    return
                }
                
                guard let response = response else { callback(HandlerType.userCallback(nil)); return }
                guard let data = data else { callback(HandlerType.userCallback(nil)); return }
                
                switch response.statusCode {
                case 200...299:
                    // danger zone below - to be refactored in lab assignment
                    let user = JSONParser.userFrom(data: data)
                    callback(HandlerType.userCallback(user))
                default:
                    print("Error: response came back with statusCode: \(response.statusCode)")
                    callback(HandlerType.userCallback(nil))
                }
            })
        }
    }
    
    // Get status for user's home timeline
    private func updateTimeline(callback: @escaping CompletionHandlerType) {
        let url = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil) {
            
            request.account = self.account
            
            request.perform(handler: { (data, response, error) in
                
                if let error = error {
                    print ("Error: Unable to request user's home timeline - \(error.localizedDescription)")
                    callback(HandlerType.tweetsCallback(nil))
                    return
                }
                
                guard let response = response else { callback(HandlerType.tweetsCallback(nil)); return }
                guard let data = data else { callback(HandlerType.tweetsCallback(nil)); return }
                
                switch response.statusCode {
                case 200...299:
                    JSONParser.tweetsFrom(data: data, callback: { (success, tweets) in
                        if success {
                            callback(HandlerType.tweetsCallback(tweets))
                        }
                    })
                case 403:
                    print("Error 403: Forbidden. Please verify that your password is entered correctly in Settings > Twitter")
                    callback(HandlerType.tweetsCallback(nil))
                case 400...499:
                    print("A client side error has occurred: \(response.statusCode).\n", "Please verify user settings and that your request is properly formatted.")
                    callback(HandlerType.tweetsCallback(nil))
                case 500...599:
                    print("A server side error has occurred: \(response.statusCode).\n", "You may wish to try again later.")
                    callback(HandlerType.tweetsCallback(nil))
                default:
                    print("Error in response from server: \(response.statusCode)")
                    callback(HandlerType.tweetsCallback(nil))
                }
                
            })
        }
        
    }
    
    // Get tweets - this public method will provide access to the private methods above
    func getTweets(callback: @escaping CompletionHandlerType) {
        if self.account == nil {
            login(callback: { (HandlerType) in
                switch (HandlerType) {
                case .accountCallback(let account):
                
                    self.account = account
                    self.updateTimeline(callback: callback)
                    break
                default:
                    break
                    }
                
            })
        } else {
            self.updateTimeline(callback: callback)
        }
    }
    
}
