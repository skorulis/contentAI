//
//  ProjectListViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 28/8/21.
//

import Foundation
import CoreData

final class ProjectListViewModel: ObservableObject {
    
    let access: ContentSourceAccess?
    
    @Published var projects: [ContentSource] = []
    
    init(access: ContentSourceAccess?) {
        self.access = access
        setupObservers()
    }
    
    private lazy var projectPublisher: FetchedResultsControllerPublisher<ContentSource>? = {
        guard let context = self.access?.database.mainContext else { return nil }
        let req: NSFetchRequest<ContentSource> = ContentSource.fetch()
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return FetchedResultsControllerPublisher(fetchedResultsController: frc)
    }()
    
    func setupObservers() {
        projectPublisher?.publisher
            
            .assign(to: &$projects)
    }
    
}

// MARK: - Behaviors

extension ProjectListViewModel {
    
}
