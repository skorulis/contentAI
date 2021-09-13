//
//  PreloadOperation.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 11/9/21.
//

import Foundation

/// Preload data from an external source
final class PreloadOperation: POperation {
    
    private let client: MagicClient
    private let access: ContentAccess
    
    var name: String = "Preload"
    
    init(factory: GenericFactory) {
        self.client = factory.resolve()
        self.access = factory.resolve()
    }
    
    func process(value: PContent) async -> PContent? {
        if value.labels.contains("missing") {
            return nil
        }
        guard let url = value.url else { return nil }
        guard let file = Self.filename(url: url) else { return nil }
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
                            access.addLabel(contentID: value.id, text: "missing")
                        }
                    }
                }
                print("Preload error \(error)")
                return nil
            }
        }
        return value
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
    
}
