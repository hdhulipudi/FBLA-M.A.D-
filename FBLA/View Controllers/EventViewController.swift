//
//  EventViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import MapKit
import CoreLocation

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
   
    @IBOutlet weak var addressButton: UIButton!
    
    
    @IBOutlet weak var enterButton: UIButton!

    @IBOutlet var QRButton: UIBarButtonItem!
    
   
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    var name = ""
    var description1 = ""
    var documentEvent:String = ""
    var qrCodeValidity1 = true
    var chapterMeetingStatus = true
    var userArray = [UserList]()
    let uuid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    var img:UIImage? = nil
    var location:GeoPoint? = nil

    
    override func viewDidLoad() {
        //Setting all changing elements to not display
        //Calling all methods that need to be called as soon as the user transitions to the viewcontroller
        enterButton.isHidden = true
        enterButton.isEnabled = false
        QRButton.isEnabled = false
        QRButton.tintColor = .clear
        tableView.alpha = 0
        userLabel.alpha = 0

        super.viewDidLoad()
        
        getEventID()
        hideElements()
        navigationItem.title = name
        
        navigationController?.navigationBar.isTranslucent = true
      

        descriptionLabel.text = description1
        
        self.hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        
        enterButton.layer.cornerRadius=10
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQRScanner" {
            if let vc1 = segue.destination as? QRScannerViewController {
                //sets the variable in the QRSCANNERVIEWCONTROLLER to the documentEvent variable of this viewcontroller
                vc1.currentEventID = documentEvent
            }
        }
    }
   
    // MARK: - Gets the Event ID (calls all the other essential functions)
    //gets event ID of the selected event
    func getEventID(){
       let eventsRef = db.collection("events")
        let query = eventsRef.whereField("name", isEqualTo: name)
         
         query.getDocuments() { (querySnapshot, err) in
                 if let err = err {
                     print("Error getting documents: \(err)")
                 } else {
                     for document in querySnapshot!.documents {
                       self.documentEvent = document.documentID
                        //all other methods that need the documentEvent are called here and then this method is called in the ViewDidLoad so the all methods run
                       self.loadData(eventID: self.documentEvent)
                        self.getDate(eventID: self.documentEvent)
                        self.getChapterMeetingStatus(eventID: self.documentEvent)
                        self.getSignUpStatus(eventID: self.documentEvent)
                        self.createQr(eventID: self.documentEvent)
                      
                     }
                 }
         }
        
    }
   // MARK: - Load Data
   // loads list of names from firestore into table view by getting the user and adding it to the user array
    func loadData(eventID:String) {
   
    db.collection("events").document(eventID).collection("users1").getDocuments { (snapshot, error) in

               if let error = error {

                   print(error.localizedDescription)

               } else {

                   if let snapshot = snapshot {

                       for document in snapshot.documents {

                           let data = document.data()
                           let firstName = data["firstName"] as? String ?? ""
                           let lastName = data["lastName"] as? String ?? ""
                           let newUser = UserList(firstName: firstName, lastName: lastName )
                           self.userArray.append(newUser)
                       }
                       self.tableView.reloadData()
                   }
               }
           }
       
       
    }
    // MARK: - Getting Date
    //gets date of the selected event
    func getDate(eventID:String){
        db.collection("events").document(eventID).getDocument { (document, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                if let document = document, document.exists{
                    //gets the date as a timeStamp
                    let tempLocation = document.get("location") as! GeoPoint
                    let tempDate = document.get("timeStamp") as! Timestamp
                    let tempAddress = document.get("address") as! String
                    //converts the timestamp to a date
                    let date = Date(timeIntervalSince1970: TimeInterval(tempDate.seconds))
                    //formats the date to a string
                    let formatter = DateFormatter()
                    formatter.dateFormat = "E, d MMM yyyy HH:mm"
                    //sets the Label to the formatted Date of the event
                    
                    self.location = tempLocation
                    self.timeLabel.text = formatter.string(from: date)
                    self.addressButton.setTitle(tempAddress, for: .normal)
                    }
            }
        }
    }
    
    // MARK: - Chapter Meeting Status
    // gets the type of event selected
    func getChapterMeetingStatus(eventID:String){
        db.collection("events").document(eventID).getDocument { (document, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else{
                if let document = document, document.exists{
                    //If its a chapter meeting the qr button will be enabled otherwise it will be disabled
                    self.chapterMeetingStatus = document.get("chapterMeeting") as! Bool
                    if self.chapterMeetingStatus{
                        self.QRButton.isEnabled = true
                        
                    }
                    else{
                        self.QRButton.isEnabled = false
                        self.QRButton.tintColor = .clear
                    }
                    
                    }
            }
        }
    }
    // MARK: - Sign Up Status
    // determines whether user has signed up for event already
       func getSignUpStatus(eventID:String){
        db.collection("events").document(eventID).collection("users1").document(uuid).getDocument { (document, error) in
               if let error = error{
                   print(error.localizedDescription)
                    
               }
               else{
                //If the user is signed up already the enter button to sign up will be disabled since they should not be able to sign up twice
                   if let document = document, document.exists{
                    self.enterButton.isEnabled = false
                    self.enterButton.isHidden = true
                    }
                   else{
                    self.enterButton.isEnabled = true
                    self.enterButton.isHidden = false
                }
               }
           }
       }
    // MARK: - Hide Elements
    //hides certain user specific elements
    func hideElements(){
        db.collection("users").document(uuid).getDocument() { (document, error) in

            if let error = error {
                
                print(error.localizedDescription)

            }
            else {

              if let document = document, document.exists {
                
                let teacherStatus = document.get("teacherStatus") as! Bool
                let hideStatus = teacherStatus
            //depending on whether the user is a teacher the respective UI elements are disabled or shown
              if hideStatus{
                
                self.enterButton.alpha = 0
               
                self.enterButton.isEnabled = false
                self.QRButton.isEnabled = true
                self.QRButton.tintColor = #colorLiteral(red: 0.6180580258, green: 0.1074862555, blue: 0.1912124157, alpha: 1)
                
                self.tableView.alpha = 1
                self.userLabel.alpha = 1
                
              }
              else {
                self.QRButton.isEnabled = false
                self.QRButton.tintColor = .clear
                self.userLabel.alpha = 0
                self.enterButton.alpha = 1
                self.enterButton.isEnabled = true

              }
               
              
                }
            }
        }
        
        
        
    }
// MARK: - QR Code Generated

    //Creates the QR code using the event ID and sets it as a UIImage
    func createQr(eventID: String){
        let myString = eventID
        if myString == eventID
        {
            
        let data = myString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        
        img = UIImage(ciImage: (filter?.outputImage)!)
        
       
        
        }
    }
    
    
   
    @IBAction func addressButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Enter Button
    //allows the user to sign up for the event
    @IBAction func enterButtonTapped(_ sender: Any) {
       let db = Firestore.firestore()
        //data of the user is added to the firebase database
        db.collection("users").document(uuid).getDocument() { (document, error) in

                      if let error = error {

                          print(error.localizedDescription)

                      }
                      else {

                        if let document = document, document.exists {
                        let firstName = document.get("firstName") as! String
                        let lastName = document.get("lastName") as! String
                            //if the event is a chapter event the user is directed to the QRCode Scanner for verification
                            if self.chapterMeetingStatus{
                                self.performSegue(withIdentifier: "toQRScanner", sender: self)
                            }
                            else{
                                db.collection("events").document(self.documentEvent).collection("users1").document(self.uuid).setData(["firstName" : firstName, "lastName":lastName])
                                self.getSignUpStatus(eventID: self.documentEvent)
                            }
                          }
                      }
                  }
        
    }
    // MARK: - Share Sheet

   //When the QR button is clicked the share sheet is displayed and the user can share the image
    @IBAction func QRButton(_ sender: Any) {
        let shareSheetVC = UIActivityViewController(activityItems: [self.img!], applicationActivities: nil)
        shareSheetVC.popoverPresentationController?.sourceView = self.view
        self.present(shareSheetVC, animated: true, completion: nil)
   
    }
   

    
    // MARK: - TableView
    //Sets the numebr of sections as 1
      func numberOfSections(in tableView: UITableView) -> Int {
          
          return 1
      }
    //Set the number of rows equal to the size of the array
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
          return userArray.count
      }

    //sets up cells and populates tableview
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")

          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
          
          let users = userArray[indexPath.row]
          
        cell.textLabel?.text = "\(users.firstName) \(users.lastName)"

          return cell
          
      }
    //Allows teacher to click on student and view information
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      
        //When clicked on the user is sent to the UserDetailsView
        let userDetailsController = self.storyboard?.instantiateViewController(identifier: "UserDetailsViewController") as! UserDetailsViewController
        //Sends the user name value of the cell clicked to the user details controller
        userDetailsController.firstName = userArray[indexPath.row].firstName
        userDetailsController.lastName = userArray[indexPath.row].lastName
       
        
        //Instantiates the view using an animation
        self.navigationController?.pushViewController(userDetailsController, animated: true)
        
    }
    //Allows teachers to delete students who have signed up
     func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let db = Firestore.firestore()
                let eventsRef = db.collection("events").document(self.documentEvent).collection("users1")
                let query = eventsRef.whereField("name", isEqualTo: self.userArray[indexPath.row].firstName)
                     
                     query.getDocuments() { (querySnapshot, err) in
                             if let err = err {
                                 print("Error getting documents: \(err)")
                             } else {
                                 for document in querySnapshot!.documents {
                                    //Deletes the user from the firebase database
                                    db.collection("events").document(self.documentEvent).collection("users1").document(document.documentID).delete()
                                     
                                 }
                             }
                     }
            //Deletes from local array
            self.userArray.remove(at: indexPath.row)
            //Deletes cell
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
        
        


    }
   
    
    


}


