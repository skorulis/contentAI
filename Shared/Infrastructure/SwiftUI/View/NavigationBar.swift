//
//  NavigationBar.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct NavigationBar {
    
    var leading: NavItem? = nil
    var middle: NavItem? = nil
    var trailing: NavItem? = nil
    
    
}

// MARK: - Rendering

extension NavigationBar: View {
    
    var body: some View {
        HStack(spacing: 4) {
            itemView(leading)
            Spacer()
            itemView(middle)
            Spacer()
            itemView(trailing)
        }
        .padding(.horizontal, 8)
        .frame(height: 44)
    }
    
    @ViewBuilder
    private func itemView(_ item: NavItem?) -> some View {
        if let item = item {
            item.view
        } else {
            EmptyView()
        }
    }
}

// MARK: - Inner types

// MARK: - Previews

struct NavigationBar_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationBar()
    }
}

