//
//  ProfileViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 2/6/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController {

    
    
    let db = Firestore.firestore()
    let uuid = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var fblaMemberLabel: UILabel!
    
    @IBOutlet weak var fblaSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }
    // MARK: - Sign OUT

    //User is transfered to the login view controller
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "ViewController")
               
               view.window?.rootViewController = viewController
               view.window?.makeKeyAndVisible()
    }
    // MARK: - FBLA Sign UP

    //When user taps sign up the user info is changed to being a member and the app displays likewise
    
    @IBAction func fblaSignUpTapped(_ sender: Any) {
        db.collection("users").document(uuid).updateData(["fblaMember" : true])
        let alert = UIAlertController(title: "Reminder", message: "Make sure to pay club dues on MyPaymentsPlus", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        fblaSignUpButton.isEnabled = false
        fblaSignUpButton.isHidden = true
        fblaMemberLabel.text = "You are an FBLA member"
        fblaMemberLabel.textColor = .systemGreen
        
           
    }
    
    
    
    
    // MARK: - Set up Labels

    func setUpLabels(){
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
                            self.fblaMemberLabel.text = "You are an FBLA Member"
                            self.fblaMemberLabel.textColor = .systemGreen
                            self.fblaSignUpButton.isHidden = true
                        }
                        else{
                            self.fblaMemberLabel.text = "You are not an FBLA Member"
                            self.fblaMemberLabel.textColor = .systemRed
                            
                        }
                        //Only displays member status if user is a student
                        if(document.get("teacherStatus") as! Bool){
                            self.fblaMemberLabel.text = ""
                            self.fblaSignUpButton.isHidden = true
                        }
                    }
                    
                }
            }
        
        }
    
    
    

}
