//
//  VStack.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/20/26.
//

import Foundation

struct VStack<each Child: Layoutable>: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let children: (repeat (each Child).LayoutSpec.FirstPass)
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let children: (repeat (each Child).LayoutSpec.SecondPass)
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }

    let alignment: LayoutAlignment.Horizontal
    let spacing: CGFloat
    let children: (repeat (each Child).LayoutSpec)

    static var dependencies: LayoutContext.Dependencies {
        var d: LayoutContext.Dependencies = []
        repeat d.formUnion((each Child).LayoutSpec.dependencies)
        d.subtract(.axis)
        return d
    }

    init(
        alignment: LayoutAlignment.Horizontal = .center,
        spacing: CGFloat = 0,
        children: (repeat each Child)
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.children = (repeat (each children).layoutSpec())
    }

    init(
        alignment: LayoutAlignment.Horizontal = .center,
        spacing: CGFloat = 0,
        @LayoutBuilder content: () -> (repeat each Child)
    ) {
        let c = content()
        self.alignment = alignment
        self.spacing = spacing
        self.children = (repeat (each c).layoutSpec())
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let ctx = ctx.with(axis: .vertical)
        let passes = (repeat (each children).firstPass(in: ctx))
        return FirstPass(
            children: (repeat each passes),
            preferredWidth: StackHelper.maxSpan(
                of: (repeat Per((each passes).preferredWidth, per: each passes))
            )
        )
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let passes = (repeat (each children).secondPass(
            for: (each firstPass.children),
            width: (each firstPass.children).preferredWidth.resolved(for: width)
        ))
        return SecondPass(
            children: (repeat each passes),
            width: width,
            preferredHeight: StackHelper.totalSpan(
                of: (repeat Per((each passes).preferredHeight, per: each passes)),
                spacing: spacing
            )
        )
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let distribution = StackHelper.distribution(
            of: (repeat Per((each secondPass.children).preferredHeight, per: each secondPass.children)),
            fitting: height,
            spacing: spacing
        )

        let hBias = -alignment.unitOffset
        let xBase = center.x.addingProduct(-hBias, secondPass.width)
        var y = center.y.addingProduct(-0.5, distribution.contentLength)
        for (c, p) in repeat (each children, each secondPass.children) {
            let h = distribution.resolvedShare(for: p.preferredHeight)
            let x = xBase.addingProduct(hBias, p.width)
            y.addProduct(0.5, h)
            c.layout(with: p, height: h, center: CGPoint(x: x, y: y))
            y.addProduct(0.5, h)
            y += spacing
        }
    }
}
