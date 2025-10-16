//
//  Persistence.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 14/10/25.
//

internal import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { desc, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }

            #if DEBUG
            print("📦 Store URL:", desc.url?.path ?? "nil")
            print("🧬 Entities:",
                  self.container.managedObjectModel.entitiesByName.keys.sorted())
            #endif
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
