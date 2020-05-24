//
//  ChatList.swift
//  FBLA
//
//  Created by Harshsai Dhulipudi on 5/24/20.
//  Copyright © 2020 Harshsai Dhulipudi. All rights reserved.
//

import Foundation

struct ChatList {
var users: String
var userIDs: String
var dictionary: [String: Any] {
    return ["users": users, "userIDs":userIDs]
   }
}
