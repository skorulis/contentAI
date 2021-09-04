//
//  NavBarItemView.swift
//  Magic
//
//  Created by Alexander Skorulis on 4/9/21.
//

import Foundation
import SwiftUI

enum NavItem {
    
    case imageButton(_ symbol: String, _ action: () -> Void)
    case text(_ text: String)
    
}

extension NavItem {
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .imageButton(let symbol, let action):
            IconButton(symbol: symbol, action: action)
        case .text(let text):
            Text(text)
        }
    }
}
