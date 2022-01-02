//
//  ContentDetailViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation

final class ContentDetailViewModel: ObservableObject {
    
    var content: ContentItem
    let project: Project?
    let labelAccess: LabelAccess
    let contentAccess: ContentAccess
    let onNext: () -> Void
    let onPrevious: () -> Void
    
    @Published var labelText: String = ""
    @Published var addingLabel: Bool = false
    @Published var globalLabel: Bool = true
    
    init(argument: Argument,
         labelAccess: LabelAccess,
         contentAccess: ContentAccess
    ) {
        self.content = argument.content
        self.project = argument.project
        self.onNext = argument.onNext
        self.onPrevious = argument.onPrevious
        self.labelAccess = labelAccess
        self.contentAccess = contentAccess
    }
}

// MARK: - Types

extension ContentDetailViewModel {
    
    struct Argument {
        let content: ContentItem
        let project: Project?
        let onNext: () -> Void
        let onPrevious: () -> Void
    }
    
}

// MARK: - Logic

extension ContentDetailViewModel {
    
    var labels: [String] {
        return content.projectLabels(project?.id)
    }
    
}

// MARK: - Behaviors

extension ContentDetailViewModel {

    func addLabel() {
        guard labelText.count > 0 else { return }
        
        addLabel(text: labelText.lowercased())
        
        labelText = ""
        self.addingLabel = false
    }
    
    func addLabel(text: String) {
        contentAccess.addLabel(content: &content, text: text, projectID: project?.id)
        self.objectWillChange.send()
    }
    
    func removeLabel(name: String) {
        contentAccess.deleteLabel(contentID: content.id, text: name, projectID: project?.id)
        content.labels = content.labels.filter { $0.name != name }
        objectWillChange.send()
    }
    
    var isUpvoted: Bool {
        return labels.contains("upvote")
    }
    
    var isDownvoted: Bool {
        return labels.contains("downvote")
    }
    
    func markViewed() {
        contentAccess.markViewed(contentID: content.id)
    }
}
