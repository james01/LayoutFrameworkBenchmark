//
//  LayoutBuilder.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/26/26.
//

import Foundation

@resultBuilder
struct LayoutBuilder {
    static func buildBlock<each Child: Layoutable>(
        _ children: repeat each Child
    ) -> (repeat each Child) {
        return (repeat each children)
    }
}
