//
//  NewProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation

final class NewSourceViewModel: ObservableObject {
    
    private let access: ContentSourceAccess?
    
    @Published var id: Int64?
    @Published var name: String = ""
    @Published var type: Source.SourceType = .reddit
    
    @Published var reddit: Reddit.SourceConfig = .init()
    
    init(arg: Argument, access: ContentSourceAccess?) {
        self.id = arg.id
        self.access = access
        if let project = loadSource() {
            self.type = project.sourceType
            self.name = project.name
            if project.sourceType == .reddit {
                if let config: Reddit.SourceConfig = project.configObject() {
                    reddit = config
                }
            }
        }
    }
}

// MARK: - Inner types

extension NewSourceViewModel {
    
    struct Argument {
        let id: Int64?
    }
    
}

// MARK: - Inner logic

extension NewSourceViewModel {
 
    func loadSource() -> Source? {
        if let id = id, let project = try? access?.get(id: id) {
            return project
        } else {
            return nil
        }
    }
    
}

// MARK: - Behaviors

extension NewSourceViewModel {
    
    var isValid: Bool {
        guard name.count > 0 else { return false }
        
        return true
    }

    func save() {
        guard isValid else { return }
        var entity = Source(
            id: id ?? 0,
            name: name,
            sourceType: type,
            config: nil)

        if type == .reddit {
            reddit.subreddit = reddit.subreddit.lowercased()
            entity.config = try? JSONEncoder().encode(reddit)
        }
        entity = access!.save(source: entity)
        
        self.id = entity.id
        
    }
    
    func delete() {
        access?.delete(id: self.id!)
    }
    
}
