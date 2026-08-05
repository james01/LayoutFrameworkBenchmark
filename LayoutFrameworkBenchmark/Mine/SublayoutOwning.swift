//
//  SublayoutOwning.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/11/26.
//

import UIKit

@MainActor protocol SublayoutOwning: LayoutResponding, UITraitChangeObservable, UITraitEnvironment {
    var sublayoutView: UIView { get }
    func invalidateSublayout()
}

extension SublayoutOwning {
    func childDidInvalidatePreferredSize() {
        invalidateSublayout()
    }
}

extension SublayoutOwning where Self: UIView {
    var sublayoutView: UIView { self }
}

extension SublayoutOwning where Self: UIViewController {
    var sublayoutView: UIView { view }
}
