//
//  Sized.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/4/26.
//

import UIKit

struct Sized<Measured: LayoutSpecifying>: LayoutSpecifying {
    unowned let view: UIView
    let measured: Measured
    
    init(_ view: UIView, to measured: Measured) {
        self.view = view
        self.measured = measured
    }
    
    static var dependencies: LayoutContext.Dependencies {
        return Measured.dependencies
    }
    
    func firstPass(in ctx: LayoutContext) -> Measured.FirstPass {
        return measured.firstPass(in: ctx)
    }
    
    func secondPass(for firstPass: Measured.FirstPass, width: CGFloat) -> Measured.SecondPass {
        return measured.secondPass(for: firstPass, width: width)
    }
    
    func layout(with secondPass: Measured.SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: height)
        view.bounds = CGRect(origin: .zero, size: size)
        view.center = center
    }
}

extension Sized<LayoutSize> {
    init(_ view: UIView, w: LayoutSpan, h: LayoutSpan) {
        self.view = view
        self.measured = LayoutSize(width: w, height: h)
    }
    
    init(_ view: UIView, _ size: CGSize) {
        self.view = view
        self.measured = LayoutSize(size: size)
    }
}
