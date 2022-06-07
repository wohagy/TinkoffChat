//
//  BaseFetchedResultsControllerDelegate.swift
//  iOS Chat
//
//  Created by Macbook on 20.04.2022.
//

import UIKit
import CoreData

final class BaseFetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    private var tableView: UITableView
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {

        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }

            tableView.insertRows(at: [newIndexPath], with: .bottom)

        case .delete:
            guard let indexPath = indexPath else { return }

            tableView.deleteRows(at: [indexPath], with: .left)

        case .move:
            guard let indexPath = indexPath,
                    let newIndexPath = newIndexPath else { return }

            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)

        case .update:
            guard let indexPath = indexPath else { return }

            tableView.reloadRows(at: [indexPath], with: .automatic)

        @unknown default:
            return
        }
    }
}
