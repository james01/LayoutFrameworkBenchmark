//
//  Fitted.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/20/26.
//

import Foundation

extension Layoutable {
    /// Fits a layout within a flexible frame. Assumes height is a linear function of width.
    func fitted() -> Fitted<LayoutSpec> {
        return Fitted(layoutSpec())
    }
}

struct Fitted<Content: LayoutSpecifying>: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let content: Content.FirstPass
        let low: Content.SecondPass
        var preferredWidth: LayoutSpan { content.preferredWidth }
    }

    struct SecondPass: SecondPassLayoutResult {
        let content: Content.FirstPass
        let low: Content.SecondPass
        let high: Content.SecondPass
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }

    let content: Content

    static var dependencies: LayoutContext.Dependencies {
        return Content.dependencies
    }

    fileprivate init(_ content: Content) {
        self.content = content
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let c = content.firstPass(in: ctx)
        return FirstPass(
            content: c,
            low: content.secondPass(for: c, width: c.preferredWidth.minimum)
        )
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let high = content.secondPass(for: firstPass.content, width: width)
        return SecondPass(
            content: firstPass.content,
            low: firstPass.low,
            high: high,
            width: width,
            preferredHeight: LayoutSpan(
                min: firstPass.low.preferredHeight.minimum,
                ideal: high.preferredHeight.ideal,
                max: high.preferredHeight.maximum
            )
        )
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let low = secondPass.low
        let high = secondPass.high

        func place(_ p: Content.SecondPass) {
            let h = p.preferredHeight.resolved(for: height)
            content.layout(with: p, height: h, center: center)
        }

        if height >= high.preferredHeight.ideal {
            place(high)
        } else if height >= low.preferredHeight.ideal {
            let rise = high.preferredHeight.ideal - low.preferredHeight.ideal
            let run = high.width - low.width
            guard rise > 0, run > 0 else { place(low); return }
            let w = low.width.addingProduct(height - low.preferredHeight.ideal, run / rise)
            let p = content.secondPass(
                for: secondPass.content,
                width: min(max(w, low.width), high.width)
            )
            assert(p.preferredHeight.ideal <= height)
            assert(height - p.preferredHeight.ideal <= 2)
            place(p)
        } else {
            place(low)
        }
    }
}
