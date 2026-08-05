//
//  BasicLayoutContainer.swift
//  Math Flashcards
//
//  Created by James Randolph on 2/28/26.
//

import UIKit

@available(*, deprecated, message: "Use Layoutable instead")
class BasicLayoutContainer: UIView, LayoutResponding {
    func childDidInvalidatePreferredSize() {
        setNeedsLayout()
    }
}
