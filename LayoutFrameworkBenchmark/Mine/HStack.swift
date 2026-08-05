//
//  HStack.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/20/26.
//

import Foundation

struct HStack<each Child: Layoutable>: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let children: (repeat (each Child).LayoutSpec.FirstPass)
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let children: (repeat (each Child).LayoutSpec.SecondPass)
        let width: CGFloat
        let contentWidth: CGFloat
        let preferredHeight: LayoutSpan
    }

    let alignment: LayoutAlignment.Vertical
    let spacing: CGFloat
    let children: (repeat (each Child).LayoutSpec)

    static var dependencies: LayoutContext.Dependencies {
        var d: LayoutContext.Dependencies = []
        repeat d.formUnion((each Child).LayoutSpec.dependencies)
        d.subtract(.axis)
        return d
    }

    init(
        alignment: LayoutAlignment.Vertical = .center,
        spacing: CGFloat = 0,
        children: (repeat each Child)
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.children = (repeat (each children).layoutSpec())
    }

    init(
        alignment: LayoutAlignment.Vertical = .center,
        spacing: CGFloat = 0,
        @LayoutBuilder content: () -> (repeat each Child)
    ) {
        let c = content()
        self.alignment = alignment
        self.spacing = spacing
        self.children = (repeat (each c).layoutSpec())
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let ctx = ctx.with(axis: .horizontal)
        let passes = (repeat (each children).firstPass(in: ctx))
        return FirstPass(
            children: (repeat each passes),
            preferredWidth: StackHelper.totalSpan(
                of: (repeat Per((each passes).preferredWidth, per: each passes)),
                spacing: spacing
            )
        )
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let distribution = StackHelper.distribution(
            of: (repeat Per((each firstPass.children).preferredWidth, per: each firstPass.children)),
            fitting: width,
            spacing: spacing
        )
        let passes = (repeat (each children).secondPass(
            for: (each firstPass.children),
            width: distribution.resolvedShare(for: (each firstPass.children).preferredWidth)
        ))
        return SecondPass(
            children: (repeat each passes),
            width: width,
            contentWidth: distribution.contentLength,
            preferredHeight: StackHelper.maxSpan(
                of: (repeat Per((each passes).preferredHeight, per: each passes))
            )
        )
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        var x = center.x.addingProduct(-0.5, secondPass.contentWidth)
        let vBias = -alignment.unitOffset
        let yBase = center.y.addingProduct(-vBias, height)
        for (c, p) in repeat (each children, each secondPass.children) {
            let h = p.preferredHeight.resolved(for: height)
            let y = yBase.addingProduct(vBias, h)
            x.addProduct(0.5, p.width)
            c.layout(with: p, height: h, center: CGPoint(x: x, y: y))
            x.addProduct(0.5, p.width)
            x += spacing
        }
    }
}
