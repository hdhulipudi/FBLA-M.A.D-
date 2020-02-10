//
//  ViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setUpElements()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = true

        self.hideKeyboardWhenTappedAround()
        
    }
    // MARK: - Set up Elements
    // UI changes
    func setUpElements(){
        //Hides Error Label
        errorLabel.alpha = 0
        loginButton.layer.cornerRadius=20
        emailTextField.layer.cornerRadius=21
        passwordTextField.layer.cornerRadius=21

           
       
       }
    // MARK: - Buttons Tapped
    // When sign up button is tapped app transitions to signupviewcontroller
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    //When login button is tapped the app verifys the email and password
    @IBAction func loginButtonTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha=1
            }
            else{
                //If succesful the app will transition to the home screen
                self.transitionToHome()
                
                
                
            }
        }
    }
    // MARK: - Transition to Home
    // Transitions to the Home View controller
    func transitionToHome(){
               
             
            let mainTabController = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! TabBarController
           
            view.window?.rootViewController = mainTabController
            view.window?.makeKeyAndVisible()
               
    }
   
}
// MARK: - Hide Keyboard
extension UIViewController {
    //This extension allows the user to exit the text field by tapping anywhere outside the text field
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

    

