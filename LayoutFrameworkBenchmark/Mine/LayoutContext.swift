//
//  LayoutContext.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/24/26.
//

import UIKit

@MainActor struct LayoutContext {
    
    struct Dependencies: OptionSet {
        let rawValue: Int
        
        static let axis                 = Dependencies(rawValue: 1 << 0)
        static let horizontalSizeClass  = Dependencies(rawValue: 1 << 1)
        
        var traits: [UITrait] {
            var t: [UITrait] = []
            if contains(.horizontalSizeClass) {
                t.append(UITraitHorizontalSizeClass.self)
            }
            return t
        }
    }
    
    var axis: Axis?
    var horizontalSizeClass: UIUserInterfaceSizeClass
    
    init(view: UIView) {
        let tc = view.traitCollection
        axis = nil
        horizontalSizeClass = tc.horizontalSizeClass
    }
    
    func with(axis: Axis?) -> LayoutContext {
        var ctx = self
        ctx.axis = axis
        return ctx
    }
}
