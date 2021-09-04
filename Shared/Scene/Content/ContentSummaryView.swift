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
    let action: () -> Void
    
}

// MARK: - Rendering

extension ContentSummaryView: View {
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title ?? "")
                    Text("\(item.labels.count) labels")
                }
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(ListRowStyle())
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
        ) {}
    }
}

