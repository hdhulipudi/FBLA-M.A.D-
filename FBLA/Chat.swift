//
//  Chat.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 5/19/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
var users: [String]
var isAnnouncement: Bool
var dictionary: [String: Any] {
    return ["users": users, "isAnnouncement":isAnnouncement]
   }
}

extension Chat {
init?(dictionary: [String:Any]) {
guard let chatUsers = dictionary["users"] as? [String],
      let announcementStatus = dictionary["isAnnouncement"] as? Bool
      else {return nil}
    self.init(users: chatUsers, isAnnouncement: announcementStatus)
}
}
