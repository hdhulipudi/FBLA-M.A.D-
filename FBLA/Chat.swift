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
var dictionary: [String: Any] {
return ["users": users]
   }
}

extension Chat {
init?(dictionary: [String:Any]) {
guard let chatUsers = dictionary["users"] as? [String] else {return nil}
self.init(users: chatUsers)
}
}
