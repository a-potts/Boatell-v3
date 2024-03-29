//
//  UserConfirmViewController.swift
//  Boatell-v3
//
//  Created by Austin Potts on 9/1/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFunctions
import Stripe

class UserConfirmViewController: UIViewController, STPPaymentContextDelegate, UITextViewDelegate {
    
    //MARK: - Interface Outlets
    
    @IBOutlet var confirmViewBox: UIView!
    @IBOutlet var serviceImage: UIImageView!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var confirmComments: UITextView!
    @IBOutlet var serviceDateLabel: UILabel!
    @IBOutlet var partLabel: UILabel!
    @IBOutlet var servicePrice: UILabel!
    
    @IBOutlet var serviceTended2: UILabel!
    @IBOutlet var serviceTended3: UILabel!
    @IBOutlet var serviceTended4: UILabel!
    
    @IBOutlet var serviceImage2: UIImageView!
    @IBOutlet var serviceImage3: UIImageView!
    @IBOutlet var serviceImage4: UIImageView!
    @IBOutlet var selectedDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceTended2.text = ""
        serviceTended3.text = ""
        serviceTended4.text = ""
        confirmComments.delegate = self
       setUpViews()
        setUp()
        
        
        fetchUser()
        let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
             self.paymentContext = STPPaymentContext(customerContext: customerContext)
             self.paymentContext.delegate = self
             self.paymentContext.hostViewController = self
             self.paymentContext.paymentAmount = 100
             
             //self.paymentContext.pushPaymentOptionsViewController()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
            confirmComments.resignFirstResponder()

               return false
           }
           return true
       }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
          
      }
      
      func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
          
      }
      
      func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
          
      }
      
      func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
          
      }
    
    init() {
           let customerContext = STPCustomerContext(keyProvider: MyAPIClient())
           self.paymentContext = STPPaymentContext(customerContext: customerContext)
           super.init(nibName: nil, bundle: nil)
           self.paymentContext.delegate = self
           self.paymentContext.hostViewController = self
           self.paymentContext.paymentAmount = 100
//           confirm.partData = part
//             print(confirm.partData.serviceName)
//             confirm.serviceDateData = serviceDate
//             print("Confirm Date \(confirm.serviceDateData!)")
//             partLabel.text = "\(confirm.partData.serviceName!)"
//             servicePrice.text = confirm.partData.servicePrice
//             serviceImage.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)
           self.paymentContext.pushPaymentOptionsViewController()
       }
       
       required init?(coder: NSCoder) {
           self.paymentContext = STPPaymentContext()
        
           super.init(coder: coder)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    
    //MARK: - Create Confirm Object to Hold Part Data + Service Date Data being passed via the segues
    let confirm = Confirm()
    var part: FirebaseServices!
    var serviceDate: String = ""
    let customALert = MyAlert()
    let ownerConfirmed = [Owner().confirmed]
    var users = [Users]()
    var user = Users()
    var selectedDate = ""
    
    var cartArray = [FirebaseServices]() {
        didSet{
            print("CONFIRM CART COUNT: \(cartArray.count)")
        }
    }

    
    //MARK: - Once you have the Passed Data (Service Date + Part) you need to add the confirm model to the Database under the user for child node "confirmed"
    
    func setUp(){
       selectedDateLabel.text = selectedDate

//        confirm.partData = part
//        print(confirm.partData.serviceName)
//        confirm.serviceDateData = serviceDate
//        print("Confirm Date \(confirm.serviceDateData!)")
//        partLabel.text = "\(confirm.partData.serviceName!)"
//        servicePrice.text = confirm.partData.servicePrice
//        serviceImage.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)
        
        var totalPrice = ""
        
        
        //MARK: - Appending Service from Cart Array to UIOutlets (Right now this only allows for 4)
        for service in cartArray {
            confirm.partData = service
            confirm.serviceDateData = serviceDate
            partLabel.text = "\(confirm.partData.serviceName!)"
            
            totalPrice.append(confirm.partData.servicePrice!)
            
             serviceImage.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)
            
            
        }
        
        if cartArray.count > 1 {
        //MARK: - This is not good code. (No flex, too static, too bug prone) FIX
        for service2 in 0..<cartArray.count - 1 {
                 confirm.partData = cartArray[service2]
                 confirm.serviceDateData = serviceDate
                 serviceTended2.text = "\(confirm.partData.serviceName!)"
                 serviceImage2.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)
             }
        
        for service3 in 0..<cartArray.count - 2 {
                         confirm.partData = cartArray[service3]
                         confirm.serviceDateData = serviceDate
                         serviceTended3.text = "\(confirm.partData.serviceName!)"
                         serviceImage3.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)

                     }
            
        }
        
        if cartArray.count > 2 {
        
        for service4 in 0..<cartArray.count - 3 {
                            confirm.partData = cartArray[service4]
                            confirm.serviceDateData = serviceDate
                            serviceTended4.text = "\(confirm.partData.serviceName!)"
                            serviceImage4.loadImageUsingCacheWithUrlString(urlString: confirm.partData.serviceImage!)

                        }
        }
        
    
        print("TOTAL PRICE: \(totalPrice)")
       
        
    }
    
    func setUpViews() {
        
        confirmButton.layer.cornerRadius = 30
        confirmViewBox.layer.cornerRadius = 30
        confirmComments.layer.cornerRadius = 20
        serviceImage.layer.cornerRadius = 30
        serviceImage2.layer.cornerRadius = 30
        serviceImage3.layer.cornerRadius = 30
        serviceImage4.layer.cornerRadius = 30
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        serviceDateLabel.text = serviceDate
    }
    
//MARK: - Action
     var paymentContext: STPPaymentContext
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        confirmServiceForUser() //Send Work Order of User to Mechanic Database
        // Present Custom Alert
        customALert.showAlertWithTitle("Service Appointment Confirmed", "An Email & Message have been sent to you, containing order details.", self)
        
        //When cofirm button is tapped, I want the owner to send the user a message
        
        //I would need to create a new handleSend() function inside this class
        handleSend() //Owner to User Message
        animateConfirm() // Animate COnfirm Button
        
        var confirmArray = [FirebaseServices]()
        //confirmArray.append(confirm)
        
        for service in cartArray {
            confirmArray.append(service)
        }
        
        print("CONFIRM COUNT: \(confirmArray.count)")
        let settingsVC = SettingsViewController()
        
        let checkoutViewController = TestNewCheckoutViewController(confirm: confirmArray, settings: settingsVC.settings)
            DispatchQueue.main.asyncAfter(deadline: .now() + 6){
                checkoutViewController.modalPresentationStyle = .fullScreen
                
            self.navigationController?.pushViewController(checkoutViewController, animated: true)
                //self.present(checkoutViewController, animated: true, completion: nil)
                
                
            }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.dismiss(animated: true, completion: nil)
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Set Up Animation
          func animateConfirm() {
              UIView.animate(withDuration: 0.2, animations: {               //45 degree rotation. USE RADIANS
                  self.confirmButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 0.1).concatenating(CGAffineTransform(scaleX: 0.8, y: 0.8))
                      
                  }) { (_) in //Is finished
                      
                      
                      UIView.animate(withDuration: 0.01, animations: {
                          self.confirmButton.transform = .identity
                      })
                                      
                  }
          }
    
     func handleSend() {
               
             // I want to send the user a message from the owner
             
               
               let ref = Database.database().reference().child("messages")
               let childRef = ref.childByAutoId()
        
                //The to id needs to be this users id
               let toID = Auth.auth().currentUser!.uid
               let fromID = "fj94U7Y9GgdMDbljI6nuW0NQZXp2"
               let timeStamp = String(NSDate().timeIntervalSince1970)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        let confirmDate = serviceDate
        
               
        let values = ["text": "Hello \(self.user.name!), I just got your service request for \(confirmDate)", "toID" : toID, "fromID" : fromID, "timeStamp" : timeStamp]
              // childRef.updateChildValues(values)
               
               let userMessagesRef = Database.database().reference().child("user-messages").child(fromID)
               let messageID = childRef.key!
               userMessagesRef.updateChildValues([messageID: 1])
               
               let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toID)
               recipientUserMessagesRef.updateChildValues([messageID: 1])
               
               // User Messages Notification 
               NotificationCenter.default.post(name: .didReceiveMessageData, object: nil)
        
               childRef.updateChildValues(values) { (error, ref) in
                   if error != nil {
                       print("Error child ref: \(error)")
                       return
                   }
                  
                   print("MESSAGE ID: \(messageID)")
               }
               
               
           }
    
    @objc func dismissAlert(){
        customALert.dismissAlert()
    }
    
    
    
    //MARK: - Fetch User From Database
    func fetchUser(){
           
           let uid = Auth.auth().currentUser?.uid
           
           Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
               
               if let dictionary = snapshot.value as? [String: AnyObject] {
                   
                   let user = Users()
                                 
                   user.setValuesForKeys(dictionary)
                   self.users.append(user)
                   self.user = user
                   
                   
               }
           }, withCancel: nil)
       }
    
    func confirmServiceForUser(){
            var users = [Users]()
            let uid = Auth.auth().currentUser?.uid
            
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    let user = Users()
                    
                                  
                    user.setValuesForKeys(dictionary)
                    users.append(user)
                    
                    
                        
                    // I need to save an array of cartArray values, but seperately in order to
                    // mantain the childByAutoID structure for services
                    for service in self.cartArray {
                        
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "yyyy-MM-dd"
                        let confirm = self.serviceDate
                        let confirmTime = self.selectedDate
                    let confirmService = service.serviceName
                        let confirmPrice = service.servicePrice
                    let clientComments = self.confirmComments.text
                    //MARK: - Add Users Name to Confirm Model
                    let userName = user.name
                    //MARK: - Add Confirm Complete Toggle to Confirm Model
                    var confirmComplete = "Not Complete"
                    
                    //MARK: - When SAVE BUTTON in Owner/ Mechanic Work Order Detail Pressed for Complete Confirm, User Should be Charged(STRIPE)
                                                
                    print("NEW CONFIRM::: \(confirm)")
                    let imageName = NSUUID().uuidString
                                                
                    let storageRef = Storage.storage().reference().child("\(imageName).png")
                    
                        if let uploadData = self.serviceImage.image?.pngData() {
                        
                        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                            if let error = error {
                                print("Error uploading image data: \(error)")
                                return
                            }
                            
                            storageRef.downloadURL { (url, error) in
                                if let error = error {
                                    print("Error downloading URL: \(error)")
                                    return
                                }
                                
                                if let confirmImage = url?.absoluteString {
                                    
                                    let values = ["confirmDate": "\(confirm)", "confirmTime" : "\(confirmTime)", "confirmService" : "\(confirmService!)", "confirmPrice" : "\(confirmPrice!)", "confirmImage" : confirmImage, "confirmComplete" : confirmComplete, "userName" : userName, "clientComments" : clientComments]
                                    
                                    
                                    guard let uid = Auth.auth().currentUser?.uid else { return }
                                    
                                    self.createCopyForUserHealth(uid: uid,values: values as [String : AnyObject])
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                } //For loop end
                        
                    
                }
            }, withCancel: nil)
        }
    
    //MARK: - Create Values For User
    func createCopyForUserHealth(uid: String, values: [String: AnyObject]) {
        var ref: DatabaseReference!
        
        ref = Database.database().reference(fromURL: "https://boatell-v3.firebaseio.com/")
        
        let userRef = ref.child("users").child(uid).child("confirmed").childByAutoId()
        //   let childRef = ref.child("confirmed").childByAutoId()
        // guard let Owner uid = Auth.auth().currentUser?.uid else { return }
        let ownerRef = ref.child("owner").child("owner").child("confirmed").childByAutoId()
        
        userRef.updateChildValues(values) { (error, refer) in
            if let error = error {
                print("ERROR CHILD values: \(error)")
                return
            }
        }
        ownerRef.updateChildValues(values) { (error, refer) in
            if let error = error {
                print("ERROR CHILD values: \(error)")
                return
            }
        }
    }
    
    
}


// Create Custom Alert Object

class MyAlert {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView: UIView = {
        let backGroundView = UIView()
        backGroundView.backgroundColor = .black
        backGroundView.alpha = 0
        return backGroundView
    }()
    
    private let alertView: UIView = {
       let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.cornerRadius = 12
        alert.layer.masksToBounds = true
        return alert
    }()
    
    private var myTargetView: UIView?
    
     func showAlertWithTitle(_ title: String, _ message: String, _ onView: UIViewController){
        guard  let targetView = onView.view else {return}
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 80, height: 200)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: 80))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        alertView.addSubview(titleLabel)
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 20, width: alertView.frame.size.width - 5, height: 170))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        alertView.addSubview(messageLabel)
        
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height - 50, width: alertView.frame.size.width, height: 50))
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }, completion: { done in
            if done {
                UIView.animate(withDuration: 0.25, animations:  {
                    self.alertView.center = targetView.center
                       })
            }
        })
        
    }
    
    @objc func dismissAlert(){
        
        guard let targetView = myTargetView else {return}
       
        
        UIView.animate(withDuration: 0.25, animations:  {
            self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width - 80, height: 200)

             }, completion: { done in
                 if done {
                     UIView.animate(withDuration: 0.25, animations:  {
                        self.backgroundView.alpha = 0
                     }, completion: { done in
                        if done {
                            self.alertView.removeFromSuperview()
                            self.backgroundView.removeFromSuperview()
                        }
                     })
                 }
             })
    }
    
}
