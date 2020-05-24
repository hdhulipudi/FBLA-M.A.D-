//
//  EventModel.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 12/23/19.
//  Copyright © 2019 Harshsai Dhulipudi. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable  {
    init?(dictionary:[String:Any])
}

//Data Model for the EVent Table View
struct Event {
    var name:String
    var description:String
    var timeStamp:Date
    var chapterMeeting:Bool
    var location:GeoPoint
    var address:String
   
    
    var dictionary:[String:Any] {
        return [
            "name":name,
            "description" : description,
            "timeStamp" : timeStamp,
            "chapterMeeting" : chapterMeeting,
            "location": location,
            "address": address
        ]
    }
    
}
//Data Model for the User Table View
struct UserList{
    var firstName:String
    var lastName:String
    
    
    var dictionary:[String:Any] {
        return [
            "firstName": firstName,
            "lastName":lastName
            
            
        ]
    }
}
//Data Model for the calendar Events
struct CalendarEvents{
    var calendarEvents:String
    
    
    var dictionary:[String:Any] {
        return [
            "name": calendarEvents
            
            
        ]
    }
}



extension Event : DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let timeStamp = dictionary ["timeStamp"] as? Date,
            let chapterMeeting = dictionary["chapterMeeting"] as? Bool,
            let location = dictionary["location"] as?
                GeoPoint,
            let address = dictionary["address"] as? String
            else {return nil}
        
        self.init(name: name, description: description, timeStamp: timeStamp, chapterMeeting: chapterMeeting,
                  location:location,address:address)
    }

}
extension UserList : DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let firstName = dictionary["firstName"] as? String,
            let lastName = dictionary["lastName"] as? String
        else {return nil}
        self.init(firstName: firstName,lastName:lastName)
    }
    
}
extension CalendarEvents : DocumentSerializable{
    init?(dictionary: [String : Any]) {
        guard let calendarEvents = dictionary["name"] as? String
        else {return nil}
        self.init(calendarEvents: calendarEvents)
    }
    
}
