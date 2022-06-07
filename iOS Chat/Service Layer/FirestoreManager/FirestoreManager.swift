//
//  FirestoreManager.swift
//  iOS Chat
//
//  Created by Macbook on 17.05.2022.
//

import Foundation
import FirebaseFirestore

protocol IFirestoreManager {
    func channelSave(channelName: String)
    func messageSave(channelID: String, message: MessageModel)
    func channelDelete(channelID: String)
}

final class FirestoreManager: IFirestoreManager {
    
    private let channelsRef = Firestore.firestore().collection("channels")
    
    func channelSave(channelName: String) {
        var toDict: [String: Any] {
                return ["lastActivity": Timestamp(date: Date()),
                        "lastMessage": String("No message yet"),
                        "name": channelName ]
        }
        channelsRef.addDocument(data: toDict)
    }
    
    func channelDelete(channelID: String) {
        channelsRef.document(channelID).delete()
    }
    
    func messageSave(channelID: String, message: MessageModel) {
        channelsRef.document(channelID).collection("messages").addDocument(data: message.toDict)
    }
}
