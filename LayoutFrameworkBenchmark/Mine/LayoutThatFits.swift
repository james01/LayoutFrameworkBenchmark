//
//  LayoutThatFits.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/8/26.
//

import Foundation

struct LayoutThatFits<each Child: LayoutSpecifying>: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let children: (repeat (each Child).FirstPass)
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let width: CGFloat
        let preferredHeight: LayoutSpan
        let layout: (CGFloat, CGPoint) -> Void
    }

    let children: (repeat each Child)
    let count: Int

    init(@LayoutBuilder content: () -> (repeat each Child)) {
        let c = content()
        var n = 0
        for _ in repeat each c { n += 1 }
        self.children = c
        self.count = n
    }

    static var dependencies: LayoutContext.Dependencies {
        var d: LayoutContext.Dependencies = []
        repeat d.formUnion((each Child).dependencies)
        return d
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let passes = (repeat (each children).firstPass(in: ctx))
        var w = LayoutSpan.zero
        var isFirst = true
        for pass in repeat each passes {
            let childWidth = pass.preferredWidth
            if isFirst {
                w.ideal = childWidth.ideal
                w.maximum = childWidth.maximum
                isFirst = false
            }
            w.minimum = childWidth.minimum
        }
        return FirstPass(children: (repeat each passes), preferredWidth: w)
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        var i = 0
        for (c, p0) in repeat (each children, each firstPass.children) {
            i += 1
            if i == count || p0.preferredWidth.minimum <= width {
                let w = p0.preferredWidth.resolved(for: width)
                let p1 = c.secondPass(for: p0, width: w)
                return SecondPass(
                    width: width,
                    preferredHeight: p1.preferredHeight,
                    layout: { (height, center) in
                        let h = p1.preferredHeight.resolved(for: height)
                        c.layout(with: p1, height: h, center: center)
                    }
                )
            }
        }
        return SecondPass(
            width: width,
            preferredHeight: .zero,
            layout: { _, _ in }
        )
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        secondPass.layout(height, center)
    }
}
