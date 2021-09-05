//
//  ContentDetailViewModel.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation

final class ContentDetailViewModel: ObservableObject {
    
    let content: PContent
    let labelAccess: LabelAccess
    
    @Published var labelText: String = ""
    
    init(content: PContent,
         labelAccess: LabelAccess
    ) {
        self.content = content
        self.labelAccess = labelAccess
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
        //guard let entity = content as? ContentEntity else { return }
        
        // TODO: FIX
        
        labelText = ""
    }
    
    func removeLabel(name: String) {
        //guard let entity = content as? ContentEntity else { return }
        //entity.labelEntities = entity.labelEntities.filter { $0.name != name }
        
        // TODO: FIX
        
        objectWillChange.send()
    }
}
