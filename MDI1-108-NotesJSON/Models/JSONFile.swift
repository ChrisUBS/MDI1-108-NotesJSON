//
//  JSONFile.swift
//  MDI1-108-NotesJSON
//
//  Created by Christian Bonilla on 14/10/25.
//

import SwiftUI
import UniformTypeIdentifiers

// A minimal FileDocument wrapper for exporting JSON via .fileExporter
public struct JSONFile: FileDocument {
    public static var readableContentTypes: [UTType] = [.json]
    public var data: Data

    public init(data: Data) { self.data = data }

    public init(configuration: ReadConfiguration) throws {
        self.data = configuration.file.regularFileContents ?? Data()
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        .init(regularFileWithContents: data)
    }
}
