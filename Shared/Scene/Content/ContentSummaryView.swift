//
//  ContentSummaryView.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 31/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct ContentSummaryView {
    
    let item: PContent
    
}

// MARK: - Rendering

extension ContentSummaryView: View {
    
    var body: some View {
        HStack {
            Text(item.title ?? "")
        }
    }
}

// MARK: - Previews

struct ContentSummaryView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentSummaryView(item: ContentItem(
            id: "1",
            title: "123",
            url: nil,
            thumbnail: nil,
            created: Date().timeIntervalSince1970,
            labels: []
        )
        )
    }
}

