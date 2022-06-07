//
//  CoreDataStackMock.swift
//  ChatTests
//
//  Created by Macbook on 19.05.2022.
//

import Foundation
import CoreData
@testable import iOS_Chat

final class CoreDataStackMock: ICoreDataStack {

    var invokedGetViewContext = false
    var invokedGetViewContextCount = 0
    var stubbedGetViewContextResult: NSManagedObjectContext!

    func getViewContext() -> NSManagedObjectContext {
        invokedGetViewContext = true
        invokedGetViewContextCount += 1
        return stubbedGetViewContextResult
    }

    var invokedFetchOnViewContext = false
    var invokedFetchOnViewContextCount = 0
    var invokedFetchOnViewContextParameters: (fetchRequest: NSFetchRequest<NSFetchRequestResult>?, Void)?
    var invokedFetchOnViewContextParametersList = [(fetchRequest: NSFetchRequest<NSFetchRequestResult>?, Void)]()
    var stubbedFetchOnViewContextResult: Any!

    func fetchOnViewContext<T>(fetchRequest: NSFetchRequest<T>) -> T? {
        invokedFetchOnViewContext = true
        invokedFetchOnViewContextCount += 1
        let fetchRequest = fetchRequest as? NSFetchRequest<NSFetchRequestResult>
        invokedFetchOnViewContextParameters = (fetchRequest, ())
        invokedFetchOnViewContextParametersList.append((fetchRequest, ()))
        return stubbedFetchOnViewContextResult as? T
    }

    var invokedPerformSaveOnViewContext = false
    var invokedPerformSaveOnViewContextCount = 0
    var stubbedPerformSaveOnViewContextBlockResult: (NSManagedObjectContext, Void)?

    func performSaveOnViewContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        invokedPerformSaveOnViewContext = true
        invokedPerformSaveOnViewContextCount += 1
        if let result = stubbedPerformSaveOnViewContextBlockResult {
            block(result.0)
        }
    }
}
