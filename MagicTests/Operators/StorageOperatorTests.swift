//
//  StorageOperatorTests.swift
//  StorageOperatorTests
//
//  Created by Alexander Skorulis on 16/9/21.
//

import Foundation
@testable import Magic
import XCTest

final class StorageOperatorTests: XCTestCase {
    
    func testThing() {
        let count = 20
        let storage = StorageOperator()
        let ids = (0..<count).shuffled()
        for i in ids {
            let item1 = ContentItem(id: "\(i)", title: "", url: "", thumbnail: "", created: Double(i), viewed: false, labels: [])
            storage.store(value: item1)
        }
        
        XCTAssertEqual(storage.storage.count, 20)
        
        for i in 0..<count {
            print(storage.storage[i].id)
            XCTAssertEqual(storage.storage[i].created, Double(19 - i))
        }
        
    }
}
