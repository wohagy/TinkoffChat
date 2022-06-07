//
//  ChannelsListener.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation
import FirebaseFirestore

protocol IChannelsListener: AnyObject {
    func channelsObserve(completion: @escaping (Result<ChannelResult, Error>) -> Void) -> ListenerRegistration?
}

final class ChannelsListener: IChannelsListener {
    
    private let db = Firestore.firestore()
    
    private var channelsRef: CollectionReference {
        return db.collection("channels")
    }
    
    func channelsObserve(completion: @escaping (Result<ChannelResult, Error>) -> Void) -> ListenerRegistration? {
        
        let chatsListener = channelsRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                guard let err = error else { return }
                completion(.failure(err))
                return
            }
            snapshot.documentChanges.forEach { (diff) in
                guard let channel = ChannelModel(document: diff.document) else { return }
                switch diff.type {
                case .added:
                    completion(.success(ChannelResult(resultState: .added, channel: channel)))
                case .modified:
                    completion(.success(ChannelResult(resultState: .modified, channel: channel)))
                case .removed:
                    completion(.success(ChannelResult(resultState: .removed, channel: channel)))
                }
            }
        }
        return chatsListener
    }
}
