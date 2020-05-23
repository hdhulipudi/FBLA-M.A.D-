//
//  TableViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class TableViewController: UITableViewController {
    
    let uuid = Auth.auth().currentUser!.uid
    var myIndex = 0
    var db:Firestore!
    let storageRef = Storage.storage().reference()

    var eventArray = [Event]()
    var filteredData = [Data]()

    var teacherStatus = true

    
    @IBOutlet var addEvent: UIBarButtonItem!
    
    @IBOutlet var settingsButton: UIBarButtonItem!
    
    /*@IBAction func settingsClicked(_ sender: Any) {
        let settingsViewController = self.storyboard?.instantiateViewController(identifier: "SettingsViewController") as! SettingsViewController
         self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    */
    override func viewDidLoad() {
        self.addEvent.isEnabled = false
        self.addEvent.tintColor = .clear
        settingsButton.isEnabled = true
        self.settingsButton.tintColor =  #colorLiteral(red: 0.6180580258, green: 0.1074862555, blue: 0.1912124157, alpha: 1)
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        db = Firestore.firestore()
        hideElements()
        
        super.viewDidLoad()
        
       
        self.customizeNavBar()
        
        //Setting up tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
      

        checkForUpdates()
        self.hideKeyboardWhenTappedAround()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
                navigationController?.navigationBar.prefersLargeTitles = true
            }
        }
    
    
    
  // MARK: - Load TableView
  //This loads the tableview by getting the data from firebase and adding it to the array
    func loadData() {
        
        db.collection("events").getDocuments() { (snapshot, error) in

               if let error = error {

                   print(error.localizedDescription)

               } else {

                   if let snapshot = snapshot {

                       for document in snapshot.documents {

                           let data = document.data()
                           let name = data["name"] as? String ?? ""
                           let description = data["description"] as? String ?? ""
                           let date = data["timeStamp"] as! Timestamp
                           let timeStamp = Date(timeIntervalSince1970: TimeInterval(date.seconds))
                    
                        
                           //let timeStamp = data["timeStamp"] as? Date ?? NSDate.now
                           let chapterMeeting = data["chapterMeeting"] as? Bool ?? true
                           let newEvent = Event(name:name, description: description, timeStamp: timeStamp, chapterMeeting: chapterMeeting)
                           self.eventArray.append(newEvent)
                       }
                       self.tableView.reloadData()
                   }
               }
           }
       
        
    }
    // MARK: - Checks for Updates

    func checkForUpdates() {
        
        db.collection("events").whereField("timeStamp", isGreaterThan: Timestamp(date: Date())).addSnapshotListener {
                querySnapshot, error in
                
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach {
                    diff in
                    
                    if diff.type == .added, let event = Event(dictionary: diff.document.data()) {
                        self.eventArray.append(event)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
        }
    }
   
    
    // MARK: - Hide Elements
    func hideElements(){
        
    //Checks user status from firebase database

           db.collection("users").document(uuid).getDocument() { (document, error) in

               if let error = error {

                   print(error.localizedDescription)

               } else {

                 if let document = document, document.exists {
                 let tempTeacherStatus = document.get("teacherStatus") as! Bool
                 let hideStatus = tempTeacherStatus
                //If the user is a teacher certain elements are hidden and certain elements are displayed
                 if !hideStatus{
                    
                    self.addEvent.isEnabled  = false
                    self.addEvent.tintColor = .clear
                    self.teacherStatus = hideStatus
                    
                 }
                 else{
                    self.addEvent.isEnabled  = true
                    self.addEvent.tintColor =  #colorLiteral(red: 0.6180580258, green: 0.1074862555, blue: 0.1912124157, alpha: 1)
                    
                    self.teacherStatus = hideStatus

                    }
                
                 
                   }
               }
           }
           
           
       }
    //Button sends to the Event View Controller through a storyboard segue
    @IBAction func addEvent(_ sender: Any) {

    }
    
    
    //Button refreshes the table view by clearing the array and repopulating it with the updated data
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.eventArray.removeAll()
        loadData()
    }
    
   
    
    

    // MARK: - Table View Methods
    //Sets the number of sections to 1 since there is only 1 section of cells
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    //Sets a constant height of 150 in the form of a CGFLOAT value
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    //Sets the number of rows in the 1 section to the size of the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventArray.count
    }
  
    //Sets up the custom cell for the TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.backgroundColor = UIColor.white
        //Sets the cell as the custom cell created in EventCell.swift
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell" , for: indexPath) as! EventCell
        // Gets the value of the array for the each row
        let event = eventArray[indexPath.row]
        // Method in EventCell.swift sets each of the values in the event array to the labels in the cell
        cell.setUpEventCell(event: event)
        
        //Returns cell to be displayed in the tableview
    
        return cell
        
    }
    // MARK: - Selecting Cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        myIndex = indexPath.row
        //When clicked on the user is sent to the EventView
        let eventViewController = self.storyboard?.instantiateViewController(identifier: "EventViewController") as! EventViewController
        //Sends the event name value of the cell clicked to the event view controller
        eventViewController.name = eventArray[indexPath.row].name
        //Sends the event description value of the cell clicked to the event view controller
        eventViewController.description1 = eventArray[indexPath.row].description
        //Instantiates the view using an animation
        self.navigationController?.pushViewController(eventViewController, animated: true)
        
    }
    
    
    // MARK: - Delete Cells
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Creates Delete action
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let db = Firestore.firestore()
            var documentEvent = ""
            let eventsRef = db.collection("events")
            //Finds the document ID of the event that is currently being deleted
            let query = eventsRef.whereField("name", isEqualTo: self.eventArray[indexPath.row].name)
                     
                     query.getDocuments() { (querySnapshot, err) in
                             if let err = err {
                                 print("Error getting documents: \(err)")
                             } else {
                                 for document in querySnapshot!.documents {
                                    documentEvent = document.documentID
                                   //Deletes the event with the documentID
                                    db.collection("events").document(documentEvent).delete()
                                     
                                 }
                             }
                     }
            
            //Removes the event from the local array
            self.eventArray.remove(at: indexPath.row)
            //Deletes the cell in the TableView
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            

        }
        //Only allowed to delete if the user is a Teacher
        if teacherStatus{
            return UISwipeActionsConfiguration(actions: [delete])
        }
        else{
            return nil
        }

}
    
}
extension UITableViewController {
    //Customizes the navigation bar
    func customizeNavBar(){
     let navBarAppearance = UINavigationBarAppearance()
     navBarAppearance.configureWithOpaqueBackground()
     navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
     navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
     navBarAppearance.backgroundColor = .white
     navBarAppearance.shadowColor = .clear

    navigationController?.navigationBar.standardAppearance = navBarAppearance
    navigationController?.navigationBar.compactAppearance = navBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.isTranslucent = false
    }
}
