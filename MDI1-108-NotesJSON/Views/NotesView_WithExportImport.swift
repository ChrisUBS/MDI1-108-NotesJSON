//
//  NotesView_WithExportImport.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 14/10/25.
//

import SwiftUI
internal import CoreData
import UniformTypeIdentifiers

struct NotesView_WithExportImport: View {
    @Environment(\.managedObjectContext) private var ctx
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.timestamp, ascending: false)],
        animation: .default
    ) private var notes: FetchedResults<Note>
    
    @State private var searchText = ""
    @State private var showingNewNote = false
    @State private var showingImporter = false
    @State private var exportFile: JSONFile?
    @State private var replaceMode = true
    @State private var selectedNote: Note?

    var filteredNotes: [Note] {
        if searchText.isEmpty { return Array(notes) }
        return notes.filter {
            ($0.title?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.content?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredNotes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title ?? "(No title)")
                            .font(.headline)
                        Text(note.content ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        if let ts = note.timestamp {
                            Text(ts.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(2)
                    .onTapGesture {
                        selectedNote = note
                    }
                }
                .onDelete(perform: deleteNotes)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Notes + JSON")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button(role: .destructive) {
                            try? deleteAllNotes()
                        } label: {
                            Label("Delete All Notes", systemImage: "trash")
                        }
                        
                        Picker("Import Mode", selection: $replaceMode) {
                            Text("Replace (wipe then import)").tag(true)
                            Text("Merge (avoid duplicates)").tag(false)
                        }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button { exportNotes() } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    Button { showingImporter = true } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    Button { showingNewNote = true } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search title or content")
            .sheet(isPresented: $showingNewNote) {
                NewNoteView()
                    .environment(\.managedObjectContext, ctx)
            }
            .sheet(item: $selectedNote) { note in 
                EditNoteView(note: note)
                    .environment(\.managedObjectContext, ctx)
            }
            .fileExporter(isPresented: Binding<Bool>(
                get: { exportFile != nil },
                set: { if !$0 { exportFile = nil } }
            ), document: exportFile, contentType: .json, defaultFilename: "notes.json") { result in
                if case .success(let url) = result {
                    print("✅ Exported to \(url)")
                }
            }
            .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) { result in
                if case .success(let url) = result {
                    try? importNotes(from: url, into: ctx, replace: replaceMode)
                }
            }
        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        for index in offsets {
            ctx.delete(filteredNotes[index])
        }
        try? ctx.save()
    }
    
    private func deleteAllNotes() throws {
        try MDI1_108_NotesJSON.deleteAllNotes(in: ctx)
    }
    
    private func exportNotes() {
        if let notes = try? fetchAllNotes(ctx),
           let data = try? JSONEncoder().encode(makeDTOs(from: notes)) {
            exportFile = JSONFile(data: data)
        }
    }
}

#Preview {
    NotesView_WithExportImport()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .preferredColorScheme(.dark)
}
