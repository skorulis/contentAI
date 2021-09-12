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
        let label = labelAccess.findOrCreate(labels: [text]).first
        contentAccess.addLabel(contentID: content.id, labelID: label!.id)
        if !content.labels.contains(text) {
            content.labels.append(text)
        }
        self.objectWillChange.send()
    }
    
    func removeLabel(name: String) {
        let label = labelAccess.findOrCreate(labels: [name]).first
        contentAccess.deleteLabel(contentID: content.id, labelID: label!.id)
        
        objectWillChange.send()
    }
}
