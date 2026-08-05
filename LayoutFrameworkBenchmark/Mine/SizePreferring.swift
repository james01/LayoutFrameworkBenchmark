//
//  SizePreferring.swift
//  Math Flashcards
//
//  Created by James Randolph on 10/13/25.
//

import UIKit

@available(*, deprecated, message: "Use Layoutable instead")
protocol SizePreferring: UIView {
    func preferredSize(for proposal: CGSize) -> CGSize
}
