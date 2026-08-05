//
//  LayoutSize.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/19/26.
//

import Foundation

struct LayoutSize: LayoutSpecifying {
    
    struct FirstPass: FirstPassLayoutResult {
        let preferredWidth: LayoutSpan
    }
    
    struct SecondPass: SecondPassLayoutResult {
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }
    
    var width: LayoutSpan
    var height: LayoutSpan
    
    static let zero = LayoutSize(size: .zero)
    
    init(size: CGSize) {
        self.width = .fixed(size.width)
        self.height = .fixed(size.height)
    }
    
    init(width: LayoutSpan, height: LayoutSpan) {
        self.width = width
        self.height = height
    }
    
    func firstPass(in ctx: LayoutContext) -> FirstPass {
        return FirstPass(preferredWidth: width)
    }
    
    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        return SecondPass(width: width, preferredHeight: height)
    }
    
    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
    }
}
