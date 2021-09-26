//
//  ChangeNotifierService.swift
//  ChangeNotifierService
//
//  Created by Alexander Skorulis on 18/9/21.
//

import Foundation
import Combine

struct ChangeNotifierService {
    
    let sourceChanged = PassthroughSubject<Source, Never>()
    let contentChanged = PassthroughSubject<ContentItem, Never>()
    
    func onChange(content: ContentItem) {
        DispatchQueue.main.async {
            contentChanged.send(content)
        }
    }
    
    func onChange(source: Source) {
        DispatchQueue.main.async {
            sourceChanged.send(source)
        }
    }
    
}
