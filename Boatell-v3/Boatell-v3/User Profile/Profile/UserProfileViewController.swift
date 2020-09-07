//
//  UserProfileViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userLocation: UILabel!
    @IBOutlet var userName: UILabel!
    
    
    @IBOutlet var serviceHistoryButton: UIButton!
    @IBOutlet var yourBoatsButton: UIButton!
    @IBOutlet var scheduleServiceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        setUpViews()
    }
    
    //MARK: - User Property Observer
        var users: User? {
              didSet {
                  updateViews()
              }
          }
    
    //MARK: - Update Views with Database Values
       func updateViews(){
           let uid = Auth.auth().currentUser?.uid

             Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
               
               
                     
                     if let dictionary = snapshot.value as? [String: AnyObject] {
                       self.userName.text = dictionary["name"] as? String
                       let profileImageURL = dictionary["profileImageURL"] as? String
                       self.userImage.loadImageViewUsingCacheWithUrlString(urlString: profileImageURL!)
                       self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
                       self.userImage.layer.masksToBounds = false
                       self.userImage.clipsToBounds = true
                     }
                     print(snapshot)
                 }, withCancel: nil)
       }
       
    
    func setUpViews(){
        serviceHistoryButton.layer.cornerRadius = 30
        yourBoatsButton.layer.cornerRadius = 30
        scheduleServiceButton.layer.cornerRadius = 30
    }
    
    

 

}