//
//  PreloadOperation.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 11/9/21.
//

import Foundation
import SQLite

/// Preload data from an external source
final class PreloadOperation: POperator {
    
    private let client: MagicClient
    private let access: ContentAccess
    
    var name: String = "Preload"
    
    init(factory: GenericFactory) {
        self.client = factory.resolve()
        self.access = factory.resolve()
    }
    
    func cache(value: inout ContentItem) async {
        if value.labelNames.contains("missing") {
            return
        }
        guard let url = value.url else { return }
        guard let file = Self.filename(url: url) else { return }
        if !FileManager.default.fileExists(atPath: file.path) {
            let req = HTTPDataRequest(endpoint: url)
            do {
                let data = try await client.executeAsync(req: req)
                try data.write(to: file)
            } catch {
                if let status = error as? HTTPStatusError {
                    switch status {
                    case .unexpectedStatus(let status):
                        if status == 404 {
                            access.addLabel(content: &value, text: "missing")
                        }
                    }
                } else if let urlError = error as? URLError, urlError.code == URLError.appTransportSecurityRequiresSecureConnection {
                    access.addLabel(content: &value, text: "missing")
                }
                print("Preload error \(error)")
                
                return
            }
        }
        access.markCached(contentID: value.id)
    }
    
    static func filename(url: String) -> URL? {
        guard let url = URL(string: url) else { return nil }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let file = url.absoluteString
            .replacingOccurrences(of: "http://", with: "")
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "/", with: "-")
        return documentsDirectory.appendingPathComponent(file)
    }
    
    static func hasPreloaded(url: String) -> Bool {
        guard let file = Self.filename(url: url) else { return false }
        return FileManager.default.fileExists(atPath: file.path)
    }
    
    func query(inputQuery: Table) -> Table {
        return inputQuery
            .filter(ContentTable.cached == true)
    }
    
    func processWaiting(inputQuery: Table) async {
        let query = inputQuery
            .filter(ContentTable.cached == false)
        
        let items = access.loadContent(query: query)
        
        for var i in items {
            await cache(value: &i)
        }
        
    }
    
}
