//
//  Spacer.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/26/26.
//

import Foundation

struct Spacer: IndependentLayoutSpecifying {
    let length: LayoutSpan
    
    static var dependencies: LayoutContext.Dependencies {
        return .axis
    }

    init(_ length: CGFloat) {
        self.length = .fixed(length)
    }
    
    init(min: CGFloat = 0, max: CGFloat = .infinity) {
        self.length = .flexible(min: min, max: max)
    }
    
    func preferredSize(in ctx: LayoutContext) -> LayoutSize {
        switch ctx.axis {
        case .horizontal:
            return LayoutSize(width: length, height: .fixed(0))
        case .vertical:
            return LayoutSize(width: .fixed(0), height: length)
        case .none:
            return LayoutSize(width: length, height: length)
        }
    }
    
    func layout(with size: CGSize, center: CGPoint) {
    }
}
