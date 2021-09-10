//
//  OperationView.swift
//  Magic
//
//  Created by Alexander Skorulis on 6/9/21.
//

import Foundation
import SwiftUI

// MARK: - Memory footprint

struct OperationView {
    
    let operation: POperation
}

// MARK: - Rendering

extension OperationView: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray)
                .frame(width: 64, height: 64)
            VStack {
                Text(operation.name)
                Text("\(operation.count)")
            }
            
        }
    }
}

// MARK: - Previews

/*struct OperationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let source = Source(id: 0, name: "123", sourceType: .reddit, config: nil)
        let op = SourceOperator(source: source)
        OperationView(operation: op)
    }
}

*/
