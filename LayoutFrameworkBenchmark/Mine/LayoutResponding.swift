//
//  LayoutResponding.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/26/26.
//

import UIKit

extension UIResponder {
    func invalidatePreferredSize() {
        guard let next else { return }
        for responder in sequence(first: next, next: \.next) {
            if let r = responder as? any LayoutResponding {
                r.childDidInvalidatePreferredSize()
                break
            }
        }
    }
}

protocol LayoutResponding: UIResponder {
    func childDidInvalidatePreferredSize()
}
