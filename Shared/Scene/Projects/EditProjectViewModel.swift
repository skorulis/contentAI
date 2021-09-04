//
//  EditProjectViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 3/9/21.
//

import Foundation

final class EditProjectViewModel: ObservableObject {
    
    var project: Project?
    private let projectAccess: ProjectAccess?
    private let sourceAccess: ContentSourceAccess?
    
    @Published var name: String = ""
    @Published var inputs: Set<ContentSource> = []
    
    init(argument: Argument,
         projectAccess: ProjectAccess?,
         sourceAccess: ContentSourceAccess?
    ) {
        self.project = argument.project
        self.projectAccess = projectAccess
        self.sourceAccess = sourceAccess
        
        if let project = project {
            name = project.name
            inputs = project.inputs
        }
        
        
    }
    
}

// MARK: - Inner types

extension EditProjectViewModel {
    
    struct Argument {
        let project: Project?
    }
}

// MARK: - Inner logic

extension EditProjectViewModel {
    
    var contentOptions: [ContentSource] {
        return sourceAccess?.all() ?? []
    }
    
}

// MARK: - Behaviors

extension EditProjectViewModel {
    
    func save() {
        guard name.count > 0 else { return }
        let context = projectAccess!.database.mainContext
        let proj = project ?? Project(context: context)
        proj.name = name
        proj.inputs = inputs
        projectAccess?.database.saveToDisk()
    }
    
    func add(source: ContentSource) {
        inputs.insert(source)
    }
    
}
