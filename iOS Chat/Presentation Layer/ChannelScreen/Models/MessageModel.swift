//
//  File.swift
//  iOS Chat
//
//  Created by Macbook on 10.03.2022.
//

import Foundation
import FirebaseFirestore

struct MessageModel: Equatable {
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
    
    init(content: String, created: Date, senderId: String, senderName: String) {
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let content = data["content"] as? String,
        let senderID = data["senderId"] as? String,
        let senderName = data["senderName"] as? String,
        let date = data["created"] as? Timestamp
         else { return nil }
        
        self.content = content
        self.created = date.dateValue()
        self.senderId = senderID
        self.senderName = senderName
    }
    
    init?(dbMessage: DBMessage?) {
 
        guard let content = dbMessage?.content,
              let created = dbMessage?.created,
              let senderID = dbMessage?.senderId,
              let senderName = dbMessage?.senderName else { return nil }
         
        self.content = content
        self.created = created
        self.senderId = senderID
        self.senderName = senderName
    }
    
    var toDict: [String: Any] {
            return ["content": content,
                    "created": Timestamp(date: created),
                    "senderId": senderId,
                    "senderName": senderName]
    }
}
