//
//  AspectRatio.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/27/26.
//

import UIKit

struct AspectRatio: LayoutSpecifying {
    
    struct FirstPass: FirstPassLayoutResult {
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }
    
    unowned let view: UIView
    let ratio: CGFloat

    init(_ view: UIView, _ ratio: CGFloat) {
        self.view = view
        self.ratio = ratio
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        return FirstPass(preferredWidth: .flexible())
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        return SecondPass(width: width, preferredHeight: .fixed(width / ratio))
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: height)
        view.bounds = CGRect(origin: .zero, size: size)
        view.center = center
    }
}
