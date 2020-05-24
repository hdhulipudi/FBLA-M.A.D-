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
import LocationPicker
import CoreLocation
import MapKit

class EventSignUpViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var chapterMeetingSwitch: UISwitch!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var location: UILabel!
    
    var db:Firestore!
    var chapterMeeting = true
    let date:Date? = nil
    var address:String = ""
    var geolocation:GeoPoint? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationController?.navigationBar.prefersLargeTitles = true
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
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.navigationBar.prefersLargeTitles = false
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
    
    
    
 
    @IBAction func locationSelected(_ sender: Any) {
        let locationPicker = LocationPickerViewController()
        navigationController?.navigationBar.prefersLargeTitles = false

        // you can optionally set initial location
       
        let latitude: CLLocationDegrees = 37.2
        let longitude: CLLocationDegrees = 22.9

        let location: CLLocation = CLLocation(latitude: latitude,
          longitude: longitude)
        let placemark = MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude:77.5011, longitude: 27.2038), addressDictionary: [:])
        let initialLocation = Location(name: "My home", location: location, placemark:  placemark)
        locationPicker.location = initialLocation

        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true

        // default: navigation bar's `barTintColor` or `UIColor.white`
        locationPicker.currentLocationButtonBackground = .blue

        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true

        locationPicker.mapType = .standard // default: .Hybrid

        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false

        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"

        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"

        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600

        locationPicker.completion = { location in
            // do some awesome stuff with location
            self.location.text = location?.address
            let lat = location?.coordinate.latitude
            print(lat)
            let long = location?.coordinate.longitude
            self.address = location?.address as! String
            self.geolocation = GeoPoint.init(latitude: lat!, longitude: long!)
            print(self.geolocation!)
        }
        navigationController?.pushViewController(locationPicker, animated: true)

       
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
        let newEvent = Event(name: name, description: description, timeStamp: eventDate, chapterMeeting: chapterMeeting, location: geolocation!, address:address)
                   
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
