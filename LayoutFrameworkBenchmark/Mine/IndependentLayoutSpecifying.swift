//
//  IndependentLayoutSpecifying.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/27/26.
//

import Foundation

struct IndependentFirstPass: FirstPassLayoutResult {
    let size: LayoutSize
    var preferredWidth: LayoutSpan { size.width }
}

struct IndependentSecondPass: SecondPassLayoutResult {
    let width: CGFloat
    let preferredHeight: LayoutSpan
}

protocol IndependentLayoutSpecifying: LayoutSpecifying where FirstPass == IndependentFirstPass, SecondPass == IndependentSecondPass {
    func preferredSize(in ctx: LayoutContext) -> LayoutSize
    func layout(with size: CGSize, center: CGPoint)
}

extension IndependentLayoutSpecifying {
    func firstPass(in ctx: LayoutContext) -> FirstPass {
        return IndependentFirstPass(
            size: preferredSize(in: ctx)
        )
    }
    
    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        return IndependentSecondPass(
            width: width,
            preferredHeight: firstPass.size.height
        )
    }
    
    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: height)
        layout(with: size, center: center)
    }
}
