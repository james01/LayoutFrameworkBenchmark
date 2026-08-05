//
//  Padded.swift
//  Math Flashcards
//
//  Created by James Randolph on 5/20/26.
//

import Foundation

extension Layoutable {
    func padded(x: CGFloat = 0, y: CGFloat = 0) -> Padded<Self, LayoutConstant<CGSize>> {
        return padded(CGSize(width: x, height: y))
    }
    
    func padded(_ inset: CGFloat) -> Padded<Self, LayoutConstant<CGSize>> {
        return padded(CGSize(width: inset, height: inset))
    }
    
    func padded(_ size: CGSize) -> Padded<Self, LayoutConstant<CGSize>> {
        return Padded(content: self, insets: LayoutConstant(size))
    }
    
    func padded(regular: CGSize, compact: CGSize) -> Padded<Self, HSizeClassDependent<CGSize>> {
        let insets = HSizeClassDependent(
            regular: regular,
            compact: compact
        )
        return Padded(content: self, insets: insets)
    }
}

struct Padded<Content: Layoutable, Insets: LayoutDynamic<CGSize>>: LayoutSpecifying {
    
    struct FirstPass: FirstPassLayoutResult {
        let content: Content.LayoutSpec.FirstPass
        let insets: CGSize
        let preferredWidth: LayoutSpan
    }
    
    struct SecondPass: SecondPassLayoutResult {
        let content: Content.LayoutSpec.SecondPass
        let insets: CGSize
        let width: CGFloat
        let preferredHeight: LayoutSpan
    }
    
    let content: Content.LayoutSpec
    let insets: Insets
    
    static var dependencies: LayoutContext.Dependencies {
        return Content.LayoutSpec.dependencies.union(Insets.dependencies)
    }
    
    fileprivate init(content: Content, insets: Insets) {
        self.content = content.layoutSpec()
        self.insets = insets
    }
    
    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let insets = insets.resolved(in: ctx)
        let c = content.firstPass(in: ctx)
        let w = c.preferredWidth.addingProduct(2, insets.width)
        return FirstPass(content: c, insets: insets, preferredWidth: w)
    }
    
    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let insets = firstPass.insets
        let insetWidth = max(0, width.addingProduct(-2, insets.width))
        let c = content.secondPass(for: firstPass.content, width: insetWidth)
        let h = c.preferredHeight.addingProduct(2, insets.height)
        return SecondPass(content: c, insets: insets, width: width, preferredHeight: h)
    }
    
    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let insetHeight = max(0, height.addingProduct(-2, secondPass.insets.height))
        content.layout(with: secondPass.content, height: insetHeight, center: center)
    }
}
