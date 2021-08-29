//
//  NewProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import CoreData

final class NewProjectViewModel: ObservableObject {
    
    private let access: ContentSourceAccess?
    
    @Published var id: String?
    @Published var source: String = ""
    @Published var name: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var type: ContentSource.SourceType = .website
    
    init(arg: Argument, access: ContentSourceAccess?) {
        self.id = arg.id
        self.access = access
        if let project = loadProject() {
            self.source = project.url ?? ""
            self.type = project.sourceType
            self.name = project.name
            self.username = project.username ?? ""
            self.password = project.password ?? ""
        }
    }
}

// MARK: - Inner types

extension NewProjectViewModel {
    
    struct Argument {
        let id: String?
    }
    
}

// MARK: - Inner logic

extension NewProjectViewModel {
 
    func loadProject() -> ContentSource? {
        if let id = id, let project = try? access?.get(id: id) {
            return project
        } else {
            return nil
        }
    }
    
}

// MARK: - Behaviors

extension NewProjectViewModel {
    
    var isValid: Bool {
        guard name.count > 0 else { return false }
        
        if type.needsURL && source.count == 0 {
            return false
        }
        if type.needsURL && (username.count == 0 || password.count == 0) {
            return false
        }
        return true
    }

    func save() {
        guard isValid else { return }
        guard let context = access?.database.mainContext else { return }
        let entity = makeProject(context: context)
        entity.name = name
        entity.sourceType = type
        if type.needsURL {
            entity.url = source
        }
        if type.needsUserPass {
            entity.username = username
            entity.password = password
        }
        
        self.id = entity.id
        access?.database.saveToDisk()
    }
    
    func delete() {
        guard let context = access?.database.mainContext else { return }
        let project = loadProject()!
        context.delete(project)
        access?.database.saveToDisk()
    }
    
    private func makeProject(context: NSManagedObjectContext) -> ContentSource {
        if let project = loadProject() {
            return project
        }
        let new = ContentSource(context: context)
        new.id = UUID().uuidString
        return new
    }
    
}
