//
//  InlineSublayout.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/3/26.
//

import UIKit

struct InlineSublayout<Content: Layoutable>: LayoutSpecifying {

    unowned let view: UIView
    let content: Content.LayoutSpec

    init(in view: UIView, content: () -> Content) {
        self.view = view
        self.content = content().layoutSpec()
    }

    static var dependencies: LayoutContext.Dependencies {
        return Content.LayoutSpec.dependencies
    }

    func firstPass(in ctx: LayoutContext) -> Content.LayoutSpec.FirstPass {
        return content.firstPass(in: ctx)
    }

    func secondPass(for firstPass: Content.LayoutSpec.FirstPass, width: CGFloat) -> Content.LayoutSpec.SecondPass {
        return content.secondPass(for: firstPass, width: width)
    }

    func layout(with secondPass: Content.LayoutSpec.SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: height)
        let bounds = CGRect(origin: .zero, size: size)
        view.bounds = bounds
        view.center = center
        content.layout(with: secondPass, height: height, center: bounds.center)
    }
}
