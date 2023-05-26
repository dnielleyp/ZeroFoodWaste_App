//
//  Sender.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 26/5/2023.
//

import UIKit
import MessageKit

class Sender: SenderType {
    
    var senderId: String
    var displayName: String
    
    init (id: String, username: String) {
        self.senderId = id
        self.displayName = username
    }

}
