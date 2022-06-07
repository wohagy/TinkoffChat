//
//  MessagesListener.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation
import FirebaseFirestore

protocol IMessagesListener: AnyObject {
    func messagesObserve(channelID: String, completion: @escaping (Result<MessageResult, Error>) -> Void) -> ListenerRegistration?
}

final class MessagesListener: IMessagesListener {
    
    private let channelsRef = Firestore.firestore().collection("channels")
    
    func messagesObserve(channelID: String, completion: @escaping (Result<MessageResult, Error>) -> Void) -> ListenerRegistration? {
        let messagesListener = channelsRef.document(channelID).collection("messages").addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                guard let err = error else { return }
                completion(.failure(err))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let message = MessageModel(document: diff.document) else {
                    return
                }
                switch diff.type {
                case .added:
                    completion(.success(MessageResult(resultState: .added, message: message)))
                case .modified, .removed:
                    break
                }
            }
        }
        return messagesListener
    }
}
