//
//  NativeImage.swift
//  Magic
//
//  Created by Alexander Skorulis on 12/9/21.
//

import Foundation
import SwiftUI

#if os(iOS)
typealias NativeImage = UIImage

extension Image {
    
    init(nativeImage: NativeImage) {
        self.init(uiImage: nativeImage)
    }
}

#else
typealias NativeImage = NSImage

extension Image {
    
    init(nativeImage: NativeImage) {
        self.init(nsImage: nativeImage)
    }
}

#endif
