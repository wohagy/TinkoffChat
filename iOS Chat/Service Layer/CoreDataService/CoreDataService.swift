//
//  NewCoreDataService.swift
//  iOS Chat
//
//  Created by Macbook on 06.04.2022.
//

import Foundation
import CoreData

protocol ICoreDataService: AnyObject {
    
    init(coreDataStack: ICoreDataStack)

    var viewContext: NSManagedObjectContext { get }
    
    func getChannelsRequest() -> NSFetchRequest<DBChannel>
    func getMessagesRequest(channelID: String) -> NSFetchRequest<DBMessage>
    
    func saveChannel(channel: ChannelModel)
    func updateChannel(channel: ChannelModel)
    func removeChannel(channel: ChannelModel)

    func saveMessage(message: MessageModel, channelId: String)
}

final class CoreDataService {
    
    private let coreDataStack: ICoreDataStack
    
    private(set) lazy var viewContext: NSManagedObjectContext = coreDataStack.getViewContext()
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    private func fetchChannel(with id: String, context: NSManagedObjectContext) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = '\(id)'")
        return try? context.fetch(fetchRequest).first
    }
    
    private func fetchChannel(with id: String) -> DBChannel? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = '\(id)'")
        return coreDataStack.fetchOnViewContext(fetchRequest: fetchRequest)
    }
    
    private func fetchMessage(channelId: String, senderId: String, created: Date) -> DBMessage? {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = NSPredicate(format: "channel.identifier == %@ AND senderId == %@ AND created == %@",
                                             argumentArray: [channelId, senderId, created])
        return coreDataStack.fetchOnViewContext(fetchRequest: fetchRequest)
    }
}

extension CoreDataService: ICoreDataService {
    
    func getChannelsRequest() -> NSFetchRequest<DBChannel> {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)]
        return fetchRequest
    }
    
    func getMessagesRequest(channelID: String) -> NSFetchRequest<DBMessage> {
        let fetchRequest: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "channel.identifier MATCHES %@", channelID)
        fetchRequest.fetchBatchSize = 10
        return fetchRequest
    }
    
    func saveChannel(channel: ChannelModel) {
        let isContains = fetchChannel(with: channel.identifier)
        guard isContains == nil else { return }
        coreDataStack.performSaveOnViewContext { context in
            let dbChannel = DBChannel(context: context)
            dbChannel.name = channel.name
            dbChannel.identifier = channel.identifier
            dbChannel.lastActivity = channel.date
            dbChannel.lastMessage = channel.message
        }
    }
    
    func updateChannel(channel: ChannelModel) {
        coreDataStack.performSaveOnViewContext { [weak self] context in
            guard let dbChannel = self?.fetchChannel(with: channel.identifier, context: context) else { return }
            dbChannel.lastMessage = channel.message
            dbChannel.lastActivity = channel.date
        }
    }
    
    func removeChannel(channel: ChannelModel) {
        coreDataStack.performSaveOnViewContext { [weak self] context in
            guard let dbChannel = self?.fetchChannel(with: channel.identifier, context: context) else { return }
            context.delete(dbChannel)
        }
    }
    
    func saveMessage(message: MessageModel, channelId: String) {
        
        let isContains = fetchMessage(channelId: channelId, senderId: message.senderId, created: message.created)
        guard isContains == nil else { return }
       
        coreDataStack.performSaveOnViewContext { [weak self] context in
            guard let channel = self?.fetchChannel(with: channelId, context: context) else { return }
            let dbMessage = DBMessage(context: context)
            dbMessage.content = message.content
            dbMessage.senderId = message.senderId
            dbMessage.created = message.created
            dbMessage.senderName = message.senderName
            channel.addToMessages(dbMessage)
        }
    }
}
