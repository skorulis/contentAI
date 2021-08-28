//
//  NewProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import CoreData

final class NewProjectViewModel: ObservableObject {
    
    private let access: ProjectAccess?
    
    @Published var id: String?
    @Published var source: String = ""
    @Published var name: String = ""
    
    init(arg: Argument, access: ProjectAccess?) {
        self.id = arg.id
        self.access = access
        if let project = loadProject() {
            self.source = project.source
            self.name = project.name
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
 
    func loadProject() -> Project? {
        if let id = id, let project = try? access?.get(id: id) {
            return project
        } else {
            return nil
        }
    }
    
}

// MARK: - Behaviors

extension NewProjectViewModel {

    func save() {
        guard source.count > 0, name.count > 0 else { return }
        guard let context = access?.database.mainContext else { return }
        let entity = makeProject(context: context)
        
        entity.source = source
        entity.name = name
        self.id = entity.id
        access?.database.saveToDisk()
    }
    
    func delete() {
        guard let context = access?.database.mainContext else { return }
        let project = loadProject()!
        context.delete(project)
        access?.database.saveToDisk()
    }
    
    private func makeProject(context: NSManagedObjectContext) -> Project {
        if let project = loadProject() {
            return project
        }
        let new = Project(context: context)
        new.id = UUID().uuidString
        return new
    }
    
}
