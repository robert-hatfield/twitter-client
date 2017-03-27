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
    
    let user = API.shared.userProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileView.userName.text = user?.name
        userProfileView.userLocation.text = user?.location
        UIImage.fetchImageWith(user!.profileImageURL, callback: { (image) in
            self.userProfileView.userImage.image = image } )
        }
    }
