//
//  EventSignUpViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/26/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class EventSignUpViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var chapterMeetingSwitch: UISwitch!
    @IBOutlet weak var createButton: UIButton!
    
    
    var db:Firestore!
    var chapterMeeting = true
    let date:Date? = nil
   


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        //UI Changes
        errorLabel.alpha = 0
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 0.5
        nameTextField.layer.cornerRadius = 5.0
        descriptionTextField.layer.borderWidth = 0.5
        descriptionTextField.layer.borderColor = UIColor.black.cgColor
        descriptionTextField.layer.cornerRadius = 5.0
        //Hide keyboard when tapped anywhere else extension
        self.hideKeyboardWhenTappedAround()

        }
    
    // MARK: - Chapter Meeting
    //If chapter meeting is selected the bool variable will be set to true or false
    @IBAction func chapterMeetingSwitch(_ sender: UISwitch) {
        if chapterMeetingSwitch.isOn{
            chapterMeeting = true
        }
        else{
            chapterMeeting = false
            
        }
    }
 
    
       
   
    
   // MARK: - Creates Event
    @IBAction func createButton(_ sender: Any) {
        //Sets the values in the textfields equal to variables and deletes any extra spaces or lines
        let name = nameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let description = descriptionTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        //Sets date selected by datepicker as a date variable
        let eventDate = datePicker.date
       
        let formatter = DateFormatter()
        //Formats the date in the format below where M is the month y is the year H is the hour d is the day and m is the minutes
        formatter.dateFormat = "E, d MMM yyyy HH:mm"

       //creates a new event using the information provided in the fields
        let newEvent = Event(name: name, description: description, timeStamp: eventDate, chapterMeeting: chapterMeeting)
                   
        var ref:DocumentReference? = nil
        //sends the new event to the Firebase Database
        ref = self.db.collection("events").addDocument(data: newEvent.dictionary) { (error) in
            if let error = error {
                print("Error adding document: \(error)")
                self.errorLabel.alpha = 1
                self.errorLabel.text = error.localizedDescription

            }
            else{
                print("Document added with ID: \(ref!.documentID)")
               
                self.dismiss(animated: true, completion: nil)
                
            }
           
        
    }

}
}
