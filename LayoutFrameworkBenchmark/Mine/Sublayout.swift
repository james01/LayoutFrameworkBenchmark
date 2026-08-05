//
//  Sublayout.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/29/26.
//

import UIKit

@MainActor struct Sublayout<Content: Layoutable> {
    private let spec: SublayoutSpec<Content.LayoutSpec>
    
    var alignment: LayoutAlignment {
        get { spec.alignment }
        nonmutating set { spec.alignment = newValue }
    }
    
    var layoutSpec: some LayoutSpecifying { spec }
    
    init<Owner: SublayoutOwning>(
        in owner: Owner,
        content: () -> Content
    ) {
        spec = SublayoutSpec(view: owner.sublayoutView, content: content().layoutSpec())
        let traits = Content.LayoutSpec.dependencies.traits
        if !traits.isEmpty {
            owner.registerForTraitChanges(traits) { (owner: Owner, _) in
                owner.invalidateSublayout()
            }
        }
    }
    
    func idealSize() -> CGSize { spec.idealSize() }
    func resolvedSize(for proposal: CGSize) -> CGSize { spec.resolvedSize(for: proposal) }
    func preferredHeight(for width: CGFloat) -> LayoutSpan { spec.preferredHeight(for: width) }
    func layoutSubviews(in bounds: CGRect) { spec.layoutSubviews(in: bounds) }
    func invalidate() -> Bool { return spec.invalidate() }
    func invalidateWithoutBubbling() { spec.invalidateWithoutBubbling() }
}

// MARK: SublayoutSpec

@MainActor private final class SublayoutSpec<Content: LayoutSpecifying> {
    private unowned let view: UIView
    private let content: Content
    private var first: Content.FirstPass?
    private var second: Content.SecondPass?
    private var laidOutBounds: CGRect = .null
    
    var alignment: LayoutAlignment = .center {
        didSet {
            guard alignment != oldValue else { return }
            laidOutBounds = .null
            view.setNeedsLayout()
        }
    }

    init(view: UIView, content: Content) {
        self.view = view
        self.content = content
    }
    
    func idealSize() -> CGSize {
        let p0 = contentFirstPass()
        let w = p0.preferredWidth.ideal
        let p1 = contentSecondPass(for: w)
        let h = p1.preferredHeight.ideal
        return CGSize(width: w, height: h)
    }
    
    func resolvedSize(for proposal: CGSize) -> CGSize {
        let p0 = contentFirstPass()
        let w = p0.preferredWidth.resolved(for: proposal.width)
        let p1 = contentSecondPass(for: w)
        let h = p1.preferredHeight.resolved(for: proposal.height)
        return CGSize(width: w, height: h)
    }
    
    func preferredHeight(for width: CGFloat) -> LayoutSpan {
        return contentSecondPass(for: width).preferredHeight
    }

    func layoutSubviews(in bounds: CGRect) {
        guard bounds != laidOutBounds else { return }
        let p0 = contentFirstPass()
        let w = p0.preferredWidth.resolved(for: bounds.width)
        let p1 = contentSecondPass(for: w)
        let h = p1.preferredHeight.resolved(for: bounds.height)
        let size = CGSize(width: w, height: h)
        let c = alignment.center(of: size, in: bounds)
        content.layout(with: p1, height: h, center: c)
        laidOutBounds = bounds
    }

    func invalidate() -> Bool {
        let oldFirst = first
        let oldSecond = second
        invalidateWithoutBubbling()

        guard let oldFirst else { return false }
        guard contentFirstPass().preferredWidth == oldFirst.preferredWidth else { return true }
        guard let oldSecond else { return false }
        return contentSecondPass(for: oldSecond.width).preferredHeight != oldSecond.preferredHeight
    }

    func invalidateWithoutBubbling() {
        first = nil
        second = nil
        laidOutBounds = .null
        view.setNeedsLayout()
    }

    private func contentFirstPass() -> Content.FirstPass {
        if let first { return first }
        let f = content.firstPass(in: LayoutContext(view: view))
        first = f
        return f
    }

    private func contentSecondPass(for width: CGFloat) -> Content.SecondPass {
        if let second, second.width == width { return second }
        let s = content.secondPass(for: contentFirstPass(), width: width)
        second = s
        return s
    }
}

// MARK: SublayoutSpec + LayoutSpecifying

extension SublayoutSpec: LayoutSpecifying {

    struct FirstPass: FirstPassLayoutResult {
        let preferredWidth: LayoutSpan
    }

    struct SecondPass: SecondPassLayoutResult {
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }

    func firstPass(in ctx: LayoutContext) -> FirstPass {
        return FirstPass(preferredWidth: contentFirstPass().preferredWidth)
    }

    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let s = contentSecondPass(for: width)
        return SecondPass(width: s.width, preferredHeight: s.preferredHeight)
    }

    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: height)
        view.bounds = CGRect(origin: .zero, size: size)
        view.center = center
    }
}
