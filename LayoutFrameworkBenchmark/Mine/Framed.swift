//
//  Framed.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/12/26.
//

import Foundation

extension Layoutable {
    func framed(
        width: LayoutSpan.Modifier = .constrained(),
        height: LayoutSpan.Modifier = .constrained()
    ) -> Framed<LayoutSpec> {
        return Framed(layoutSpec(), width: width, height: height)
    }
}

struct Framed<Content: LayoutSpecifying>: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let content: Content.FirstPass
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let content: Content.SecondPass
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }

    let content: Content
    let width: LayoutSpan.Modifier
    let height: LayoutSpan.Modifier

    static var dependencies: LayoutContext.Dependencies {
        return Content.dependencies
    }

    fileprivate init(
        _ content: Content,
        width: LayoutSpan.Modifier,
        height: LayoutSpan.Modifier
    ) {
        self.content = content
        self.width = width
        self.height = height
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let c = content.firstPass(in: ctx)
        return FirstPass(
            content: c,
            preferredWidth: c.preferredWidth.applying(width)
        )
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let contentWidth = firstPass.content.preferredWidth.resolved(for: width)
        let c = content.secondPass(for: firstPass.content, width: contentWidth)
        return SecondPass(
            content: c,
            width: width,
            preferredHeight: c.preferredHeight.applying(height)
        )
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let contentHeight = secondPass.content.preferredHeight.resolved(for: height)
        content.layout(with: secondPass.content, height: contentHeight, center: center)
    }
}
