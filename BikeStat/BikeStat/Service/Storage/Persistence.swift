//
//  Persistence.swift
//

import CoreData

struct PersistenceController {

    // MARK: - Static Properties

    static let shared = PersistenceController()

    // MARK: - Inits

    init() {
        container = NSPersistentContainer(name: "Rides")

        container.loadPersistentStores { description, error in
            if let error  {
                fatalError("DEBUG: Unresolved error \(error.localizedDescription)")
            }
        }

        viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Private Properties

    private let container: NSPersistentContainer

    // MARK: - Internal Properties

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
}
