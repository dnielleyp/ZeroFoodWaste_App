//
//  ChatMessage.swift
//  ZeroFoodWaste
//
//  Created by Danielle Yap on 26/5/2023.
//

import UIKit
import MessageKit

class ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init (sender: Sender, messageId: String, sentDate: Date, message: String) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = sentDate
        self.kind = .text(message)

        
    }
}
