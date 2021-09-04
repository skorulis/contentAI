//
//  IconButton.swift
//  VoidShaperClient
//
//  Created by Alexander Skorulis on 7/8/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct IconButton {
    
    let symbol: String
    let action: () -> ()
}

// MARK: - Rendering

extension IconButton: View {
    
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                //.frame(width: 20, height: 20)
        }
    }
}

// MARK: - Previews

struct IconButton_Previews: PreviewProvider {
    
    static var previews: some View {
        IconButton(symbol: "xmark.circle.fill", action: {})
    }
}

