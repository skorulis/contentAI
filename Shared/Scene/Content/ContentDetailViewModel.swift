//
//  ContentDetailViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation

final class ContentDetailViewModel: ObservableObject {
    
    var content: PContent
    let labelAccess: LabelAccess
    let contentAccess: ContentAccess
    
    @Published var labelText: String = ""
    
    init(content: PContent,
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
        contentAccess.addLabel(contentID: content.id, text: text)
        if !content.labels.contains(text) {
            content.labels.append(text)
        }
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
