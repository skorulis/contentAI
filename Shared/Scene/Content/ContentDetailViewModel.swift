//
//  ContentDetailViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation

final class ContentDetailViewModel: ObservableObject {
    
    var content: ContentItem
    let labelAccess: LabelAccess
    let contentAccess: ContentAccess
    
    @Published var labelText: String = ""
    
    init(content: ContentItem,
         labelAccess: LabelAccess,
         contentAccess: ContentAccess
    ) {
        self.content = content
        self.labelAccess = labelAccess
        self.contentAccess = contentAccess
    }
}

// MARK: - Logic

extension ContentDetailViewModel {
    
    var labels: [String] {
        return content.labels
    }
    
}

// MARK: - Behaviors

extension ContentDetailViewModel {

    func addLabel() {
        guard labelText.count > 0 else { return }
        
        addLabel(text: labelText.lowercased())
        
        labelText = ""
    }
    
    func addLabel(text: String) {
        contentAccess.addLabel(content: &content, text: text)
        self.objectWillChange.send()
    }
    
    func removeLabel(name: String) {
        contentAccess.deleteLabel(contentID: content.id, text: name)
        content.labels = content.labels.filter { $0 != name }
        objectWillChange.send()
    }
    
    var isUpvoted: Bool {
        return content.labels.contains("upvote")
    }
    
    var isDownvoted: Bool {
        return content.labels.contains("downvote")
    }
    
    func markViewed() {
        contentAccess.markViewed(contentID: content.id)
    }
}
