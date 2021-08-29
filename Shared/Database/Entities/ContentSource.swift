//
//  Project.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import CoreData
import Foundation

@objc(ContentSource)
public class ContentSource: NSManagedObject {

    @nonobjc class func fetch() -> NSFetchRequest<ContentSource> {
        return NSFetchRequest<ContentSource>(entityName: "ContentSource")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var authData: Data?
    
    @NSManaged private var sourceTypeString: String
    
    var sourceType: SourceType {
        get {
            return SourceType(rawValue: sourceTypeString) ?? .website
        }
        set {
            sourceTypeString = newValue.rawValue
        }
    }
    
    func authObject<T: Decodable>() -> T? {
        guard let data = authData else { return nil }
        return try! JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Inner types

extension ContentSource: Identifiable {
    
    enum SourceType: String, Identifiable, CaseIterable {
        case website
        case reddit
        
        var id: String { rawValue }
        
        var needsURL: Bool {
            switch self {
            case .website: return true
            default: return false
            }
        }
        
        var needsUserPass: Bool {
            switch self {
            case .reddit: return true
            default: return false
            }
        }
    }
    
}

