//
//  NavigationLazyView.swift
//  Crypto
//
//  Created by Alexander Skorulis on 15/5/21.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
