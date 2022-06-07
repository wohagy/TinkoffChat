//
//  ChannelsListCellsModel.swift
//  iOS Chat
//
//  Created by Macbook on 09.03.2022.
//

import Foundation
import FirebaseFirestore

struct ChannelModel: Equatable {
    let identifier: String
    let name: String
    let message: String?
    let date: Date?
    
    init(identifier: String, name: String, message: String?, date: Date?) {
        self.identifier = identifier
        self.name = name
        self.message = message
        self.date = date
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String,
              let message = data["lastMessage"] as? String,
              let date = data["lastActivity"] as? Timestamp else { return nil }
        
        self.name = name
        self.message = message
        self.identifier = document.documentID
        self.date = date.dateValue()
    }
}
