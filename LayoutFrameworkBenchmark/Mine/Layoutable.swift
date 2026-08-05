//
//  Layoutable.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/20/26.
//

import Foundation

@MainActor protocol Layoutable<LayoutSpec> {
    associatedtype LayoutSpec: LayoutSpecifying
    func layoutSpec() -> LayoutSpec
}
