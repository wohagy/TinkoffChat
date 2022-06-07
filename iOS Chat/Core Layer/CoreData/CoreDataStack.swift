//
//  CoreDataStack.swift
//  iOS Chat
//
//  Created by Macbook on 19.04.2022.
//

import Foundation
import CoreData

protocol ICoreDataStack {
    func getViewContext() -> NSManagedObjectContext
    func fetchOnViewContext<T>(fetchRequest: NSFetchRequest<T>) -> T?
    func performSaveOnViewContext(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataStack: ICoreDataStack {
    
    private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()
    
    func getViewContext() -> NSManagedObjectContext {
        return container.viewContext
    }
    
    func fetchOnViewContext<T>(fetchRequest: NSFetchRequest<T>) -> T? {
        return try? container.viewContext.fetch(fetchRequest).first
    }
    
    func performSaveOnViewContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = container.viewContext
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try self.performSave(in: context)
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func performSave(in context: NSManagedObjectContext) throws {
        try context.save()
        if let parent = context.parent {
            try performSave(in: parent)
        }
    }
    
}
