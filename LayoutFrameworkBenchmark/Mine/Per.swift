//
//  Per.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/2/26.
//

import Foundation

struct Per<Phantom, Value> {
    var value: Value

    init(_ value: Value) {
        self.value = value
    }
    
    init(_ value: Value, per: Phantom) {
        self.init(value)
    }
}
