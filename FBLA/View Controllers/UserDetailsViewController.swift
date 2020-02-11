//
//  UserDetailsViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 2/11/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase

class UserDetailsViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    @IBOutlet weak var fblaMemberLabel: UILabel!
    
   
    
    @IBOutlet weak var phoneButton: UIButton!
    
    let db = Firestore.firestore()
    var firstName = ""
    var lastName = ""

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getUUID()
    }
    
// MARK: - Buttons Tapped
    

    
    @IBAction func phoneButtonTapped(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "tel://\((phoneNumberLabel.text! as NSString).integerValue)")! as URL)
    }
    
    
    
    
// MARK: - GETS UUID also invokes SETUPLABELS Method

    
    //Gets the userID
    func getUUID() {
       let usersRef = db.collection("users")
       
       let query = usersRef.whereField("firstName", isEqualTo: firstName).whereField("lastName", isEqualTo:lastName)
         
         query.getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                       let uuid = document.documentID
                        //SetupLabels method is passed with the userId string so that the labels will be set with the informatoin for the user
                        self.setUpLabels(uuid: uuid)
                      
                       
                      
                     }
                 }
         }
 
        
    }
    
    
    
    
    
    
    
    // MARK: - SetUpLabels
    //Sets up the labels to have the right information for the respective user

    func setUpLabels(uuid: String){
               db.collection("users").document(uuid).getDocument { (document, error) in
                   if let error = error
                   {
                       print(error)
                   }
                   else {
                       //Gets user information from the firebase database and sets the UI elements to the data
                       if let document = document, document.exists{
                           let firstName:String = document.get("firstName") as! String
                           let lastName:String = document.get("lastName") as! String
                           
                           self.nameLabel.text = ("\(firstName) \(lastName)")
                           self.phoneNumberLabel.text = document.get("phoneNumber") as? String
                           self.emailLabel.text = document.get("email") as? String
                           //Message displayed depending on if user is an fbla member
                           if(document.get("fblaMember") as! Bool){
                               self.fblaMemberLabel.text = "Student is an FBLA Member"
                               self.fblaMemberLabel.textColor = .systemGreen
                               
                           }
                           else{
                               self.fblaMemberLabel.text = "Student is not an FBLA Member"
                               self.fblaMemberLabel.textColor = .systemRed
                               
                           }
                           //Only displays member status if user is a student
                           if(document.get("teacherStatus") as! Bool){
                               self.fblaMemberLabel.text = ""
                               
                           }
                       }
                        
                   }
               }
           
           }
    
}
