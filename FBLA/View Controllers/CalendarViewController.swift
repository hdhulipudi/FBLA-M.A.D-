//
//  CalendarViewController.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase



class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate,FSCalendarDataSource {
    
    fileprivate weak var calendar: FSCalendar!
    

    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var calendarArray = [CalendarEvents]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    
   
    // MARK: - Query Date

    //finds documents with the date selected in the calendar and creates an array with the events
    func queryDate(selectedTimeStamp:Timestamp,endTimeStamp:Timestamp)
    {
       
        db.collection("events").whereField("timeStamp", isGreaterThan:  (selectedTimeStamp)).whereField("timeStamp", isLessThan: endTimeStamp).getDocuments(){ (querySnapshot, err) in
           
            if let err = err {
                print("Error getting documents: \(err)")
                   }
            else {
                for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let data = document.data()
                let event = data["name"] as? String ?? ""
                let newEvent = CalendarEvents(calendarEvents: event)
                self.calendarArray.append(newEvent)
                }
                
                self.tableView.reloadData()
                
            
        }
        
    }
    }
    // MARK: - Calendar Dunctions

   //Calendar function to run the queryDate method for the date selected
    func calendar(_ calendar: FSCalendar, didSelect selectedDate: Date, at monthPosition: FSCalendarMonthPosition) {
        self.calendarArray.removeAll()
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        let endTimestamp:Timestamp = Timestamp(date: endDate)
        let selectedTimestamp:Timestamp = Timestamp(date: selectedDate)
        queryDate(selectedTimeStamp: selectedTimestamp, endTimeStamp: endTimestamp)
   
    }
    
    //Calendar function to check to see if each date has an event
    
      func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
         let startTimeStamp:Timestamp = Timestamp(date: date)
         let endDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let endTimeStamp:Timestamp = Timestamp(date: endDate)


         //display events as dots
         cell.eventIndicator.isHidden = false
         cell.eventIndicator.color = UIColor.blue
        
        db.collection("events").whereField("timeStamp", isGreaterThan:  (startTimeStamp)).whereField("timeStamp", isLessThan: endTimeStamp).getDocuments(){ (querySnapshot, err) in
               
                if let err = err {
                    print("Error getting documents: \(err)")
                       }
                else {
                    for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                      cell.eventIndicator.numberOfEvents = 1
                    }
                    
                   
                    
                
            }
            
        }

         
     }
    // MARK: - Table View Functions

    //Sets the number of sections as 1
    func numberOfSections(in tableView: UITableView) -> Int {
             
             return 1
         }
    //Sets the number of rows in the tableview as the size of the array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             
             return calendarArray.count
         }

    //sets up the cells and populates the tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")

             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
             
             let calendarEvents = calendarArray[indexPath.row]
        
             cell.textLabel?.text = "\(calendarEvents.calendarEvents)"
             
            

             return cell
             
         }
    



}


