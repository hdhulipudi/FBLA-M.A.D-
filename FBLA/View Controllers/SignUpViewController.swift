//
//  SignUpViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore



class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var teacherSwitch: UISwitch!
    
    var teacherStatus = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setUpElements()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true

        navigationController?.setNavigationBarHidden(false, animated: true)

    }
    func setUpElements(){
        //Hides Error Label
        errorLabel.alpha = 0
        
        
        //Style your ELEMENTS HERE
    
    }
    // MARK: - Validating Fields
    //Checks to see if text fields are empty and if they are the method returns a string saying the user needs to enter their information
    func validateFields()-> String?{
        //Checks to see if text fields are empty
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""||phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
           return "Please fill in all information"
        }
        
        return nil
    }
    // MARK: - Teacher Switch
    //Changes whether the user signing up is a student or a teacher
    @IBAction func teacherSwitch(_ sender: UISwitch) {
        if teacherSwitch.isOn{
            teacherStatus = true
        }
        else{
            teacherStatus = false
        }
    }
    
   
    // MARK: - Sign Up Button Tapped
    
    @IBAction func signUpTapped(_ sender: Any) {
    //Error is set to the string returned by the method
    let error = validateFields()
        if error != nil{
            // if there is an error error label is made visible with error
            errorLabel.text = error!
            errorLabel.alpha = 1
        }
        else{
        //Sets the text in the text fields to string variables and removes any extra lines or spaces
        let firstName = firstNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let lastName = lastNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneNumber = phoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Using the email and password entered the user is created in the Firestore Cloud database
           Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //If there is an error the error will be displayed
                    self.errorLabel.text = err?.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else{
                    let db = Firestore.firestore()
                    // If there is no error then the addition user information will be added to the Firestore Cloud Database
                    db.collection("users").document(result!.user.uid).setData(["firstName":firstName,"lastName":lastName,"teacherStatus":self.teacherStatus,"phoneNumber":phoneNumber,"email":email,"fblaMember":false])
                    //After data is added the user is sent to the Home ViewController
                    
                    self.transitionToHome()

                    
                }
            
            }
            
        }

        
    }
    // MARK: - Transition to Home
    //Sends user to the home screen
    func transitionToHome(){
        
         let mainTabController = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
                  
         view.window?.rootViewController = mainTabController
         view.window?.makeKeyAndVisible()
        
    }

}
