//
//  EditNoteView.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 16/10/25.
//

import SwiftUI
internal import CoreData

struct EditNoteView: View {
    @Environment(\.managedObjectContext) private var ctx
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var note: Note
    @State private var title: String = ""
    @State private var content: String = ""
    
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
            .navigationTitle("Edit Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                        dismiss()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .onAppear {
                title = note.title ?? ""
                content = note.content ?? ""
            }
        }
    }
    
    private func saveChanges() {
        note.title = title
        note.content = content
        note.timestamp = Date()
        try? ctx.save()
    }
}

#Preview {
    let ctx = PersistenceController.shared.container.viewContext
    let sample = Note(context: ctx)
    sample.title = "Example Note"
    sample.content = "Example content"
    sample.timestamp = Date()
    
    return EditNoteView(note: sample)
        .environment(\.managedObjectContext, ctx)
        .preferredColorScheme(.dark)
}
