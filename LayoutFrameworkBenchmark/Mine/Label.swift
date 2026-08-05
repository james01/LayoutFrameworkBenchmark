//
//  Label.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/31/26.
//

import UIKit

class Label: UILabel {
    var trimsDescender = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Listen for trait changes
        let traits: [UITrait] = [
            UITraitLegibilityWeight.self,
            UITraitPreferredContentSizeCategory.self
        ]
        registerForTraitChanges(traits) { (self: Self, _) in
            DispatchQueue.main.async {
                self.invalidatePreferredSize()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: LayoutSpecifying

extension Label: LayoutSpecifying {
    
    struct FirstPass: FirstPassLayoutResult {
        let preferredWidth: LayoutSpan
    }
    
    struct SecondPass: SecondPassLayoutResult {
        let width: CGFloat
        let textHeight: CGFloat
        let preferredHeight: LayoutSpan
    }
    
    func firstPass(in ctx: LayoutContext) -> FirstPass {
        let s = intrinsicContentSize
        return FirstPass(preferredWidth: .greedy(max: s.width))
    }
    
    func secondPass(for firstPass: FirstPass, width: CGFloat) -> SecondPass {
        let proposed = CGSize(width: width, height: .greatestFiniteMagnitude)
        let textHeight = sizeThatFits(proposed).height
        var boxHeight = textHeight
        if trimsDescender { boxHeight += font.descender }
        return SecondPass(
            width: width,
            textHeight: textHeight,
            preferredHeight: .fixed(boxHeight)
        )
    }
    
    func layout(with secondPass: SecondPass, height: CGFloat, center: CGPoint) {
        let size = CGSize(width: secondPass.width, height: secondPass.textHeight)
        let y = trimsDescender ? center.y.addingProduct(-0.5, font.descender) : center.y
        self.bounds = CGRect(origin: .zero, size: size)
        self.center = CGPoint(x: center.x, y: y)
    }
}
