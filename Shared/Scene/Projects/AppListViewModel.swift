//
//  ProjectListViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import CoreData

final class AppListViewModel: ObservableObject {
    
    let sourceAccess: ContentSourceAccess?
    let projectAccess: ProjectAccess?
    
    @Published var sources: [Source] = []
    @Published var projects: [Project] = []
    
    init(sourceAccess: ContentSourceAccess?,
         projectAccess: ProjectAccess?
    ) {
        self.sourceAccess = sourceAccess
        self.projectAccess = projectAccess
        setupObservers()
    }
    
    //private lazy var sourcePublisher: FetchedResultsControllerPublisher<ContentSource>? = sourceAccess?.publisher()
    
    //private lazy var projectPublisher: FetchedResultsControllerPublisher<Project>? = projectAccess?.puublisher()
    
    func setupObservers() {
        sources = sourceAccess?.all() ?? []
        
        
        //sourcePublisher?.publisher
            //.assign(to: &$sources)
        
        //projectPublisher?.publisher
          //  .assign(to: &$projects)
    }
    
}

// MARK: - Behaviors

extension AppListViewModel {
    
}
