//
//  MDI1_108_NotesJSONApp.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 14/10/25.
//

import SwiftUI
internal import CoreData

@main
struct MDI1_108_NotesJSONApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            NotesView_WithExportImport()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
