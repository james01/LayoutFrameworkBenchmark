//
//  LayoutSpecifying.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/29/26.
//

import Foundation

protocol FirstPassLayoutResult {
    var preferredWidth: LayoutSpan { get }
}

protocol SecondPassLayoutResult {
    var width: CGFloat { get }
    var preferredHeight: LayoutSpan { get }
}

@MainActor protocol LayoutSpecifying: Layoutable {
    associatedtype FirstPass: FirstPassLayoutResult
    associatedtype SecondPass: SecondPassLayoutResult
    static var dependencies: LayoutContext.Dependencies { get }
    func firstPass(in ctx: LayoutContext) -> FirstPass
    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass
    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint)
}

extension LayoutSpecifying {
    func layoutSpec() -> Self {
        return self
    }
    
    static var dependencies: LayoutContext.Dependencies {
        return []
    }
}
