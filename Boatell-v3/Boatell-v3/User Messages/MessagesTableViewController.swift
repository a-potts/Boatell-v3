//
//  MessagesTableViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    
    var messages = [Message]()

    override func viewDidLoad() {
           super.viewDidLoad()
           
        
       
           let newMessageController = NewMessagesTableViewController()
                  newMessageController.messagesController = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
         
        observeMessages()
        
       }
       
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let message = Message()
                message.setValuesForKeys(dictionary)
                self.messages.append(message)
                print("Messages Snapshot: \(snapshot)")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        
            
        }, withCancel: nil)
    }
       
       
       func checkIfUserLoggedIn(){
           //MARK: - Check if user is singed in FIXME
           if Auth.auth().currentUser?.uid == nil {
               self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
           } else {
               let uid = Auth.auth().currentUser?.uid
               Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                   
                   if let dictionary = snapshot.value as? [String:AnyObject] {
                       self.navigationItem.title = dictionary["name"] as? String
                   }
                   
                   
                   
                   //print(snapshot)
               }, withCancel: nil)
           }
       }

       // MARK: - Table view data source

    
    

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
        return messages.count
       }
    

    
    //MARK: BUG - In Users Recieved Messages, User can current view the Owners message but not the image or the name. This may be due to how the Owenr is being stored
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        var timeLabel: UILabel = {
            let label = UILabel()
            label.text = "HH:MM:SS"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor.darkGray
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        
        let message = messages[indexPath.row]
        
        if let toID = message.toID {
            let ref = Database.database().reference().child("owner").child("owner").child(toID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
               
                      if let dictionary = snapshot.value as? [String: AnyObject] {
                        print("SNAP: \(snapshot.value)")
                        
                       cell.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageURL"] as? String {
                            cell.imageView?.image = UIImage(named: "User")
                            cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                            cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)! / 2
                            cell.imageView?.layer.masksToBounds = true
                            
                            tableView.reloadData()
                        }
                        
                    }
            }, withCancel: nil)
            
               }
       
        //THIS IS A TEMPORARY FIX
        cell.textLabel?.text = "Owner"
        cell.detailTextLabel?.text = message.text
        
      
        
        
        
        
        print(message.timeStamp)
        
//        let sec = NSNumber(pointer: message.timeStamp)
//
//        let seconds = sec.doubleValue
//        let timeStamp = Date(timeIntervalSince1970: seconds)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss a"
        
       
      
        //print("DATE \(dateFormatter.string(from: date!))")
        
        timeLabel.text = message.timeStamp
         
        
        cell.addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: cell.textLabel!.heightAnchor).isActive = true
        
        return cell
        
    }
       
       
       @IBAction func logoutTapped(_ sender: Any) {
               do {
                     try Auth.auth().signOut()
                 } catch let logoutError{
                     print(logoutError)
                 }
                 
               //  let loginController = LoginViewController()


       self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
         
       
           
       }
       
       @IBAction func chatTapped(_ sender: Any) {
           
           //showChatController()
           
       }
       
//       func showChatControllerForUser(user: User) {
//
//           let chatLogController = ChatLogsViewController()
//           chatLogController.user = user
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogsViewController
//        self.navigationController?.pushViewController(resultViewController, animated: true)
//
//       }

      
       
       // MARK: - Navigation

       // In a storyboard-based application, you will often want to do a little preparation before navigation
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           if segue.identifier == "NewMessageSegue" {
               if let newMessVC = segue.destination as? NewMessagesTableViewController {
                newMessVC.messagesController = self
               }
          }
           // Pass the selected object to the new view controller.
       }
       


}
