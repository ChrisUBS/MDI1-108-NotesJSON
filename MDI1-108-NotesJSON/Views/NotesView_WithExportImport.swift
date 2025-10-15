//
//  NotesView_WithExportImport.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 14/10/25.
//

import SwiftUI

struct NotesView_WithExportImport: View {
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Note 1")
                            .font(.headline)
                        Text("Hello!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("14 Oct 2025 at 7:40 p.m.")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Note 2")
                            .font(.headline)
                        Text("Hello!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("14 Oct 2025 at 7:40 p.m.")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(2)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Note 3")
                            .font(.headline)
                        Text("Hello!")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("14 Oct 2025 at 7:40 p.m.")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(2)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Notes + JSON")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("gear")
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        print("export")
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }

                    Button {
                        print("import")
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }

                    Button {
                        print("add")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search title or content")
        }
    }
}

#Preview {
    NotesView_WithExportImport()
        .preferredColorScheme(.dark)
}
