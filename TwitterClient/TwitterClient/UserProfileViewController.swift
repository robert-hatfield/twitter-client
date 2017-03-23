//
//  UserProfileViewController.swift
//  TwitterClient
//
//  Created by Robert Hatfield on 3/22/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet var userProfileView: UserProfileView!
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileView.userName.text = user.name
        userProfileView.userLocation.text = user.location
//        userProfileView.userImage
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
