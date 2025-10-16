//
//  NewNoteView.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 16/10/25.
//

import SwiftUI
internal import CoreData

struct NewNoteView: View {
    @Environment(\.managedObjectContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("e.g. Project ideas", text: $title)
                }
                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 150)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addNote()
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func addNote() {
        let note = Note(context: ctx)
        note.title = title
        note.content = content
        note.timestamp = Date()
        try? ctx.save()
    }
}

#Preview {
    NewNoteView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
}
