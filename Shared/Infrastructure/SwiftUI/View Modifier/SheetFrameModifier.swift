//
//  SheetFrameModifier.swift
//  Magic (iOS)
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import SwiftUI

struct SheetFrameModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .frame(width: 500, height: 500)
        #else
            content
        #endif
    }
}
