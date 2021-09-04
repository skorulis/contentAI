//
//  ListRowStyle.swift
//  Magic
//
//  Created by Alexander Skorulis on 2/9/21.
//

import Foundation
import SwiftUI

struct ListRowStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 4).stroke(Color.black)
            )
    }
}
