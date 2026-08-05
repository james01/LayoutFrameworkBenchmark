//
//  LayoutAlignment.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/31/26.
//

import Foundation

struct LayoutAlignment: Equatable {
    
    enum Horizontal {
        case left, center, right
        
        var unitOffset: CGFloat {
            switch self {
            case .left: -0.5
            case .center: 0
            case .right: 0.5
            }
        }
        
    }
    enum Vertical {
        case top, center, bottom
        
        var unitOffset: CGFloat {
            switch self {
            case .top: -0.5
            case .center: 0
            case .bottom: 0.5
            }
        }
    }
    
    var horizontal: Horizontal
    var vertical: Vertical
    
    static let center = LayoutAlignment(
        horizontal: .center,
        vertical: .center
    )
    
    static let left = LayoutAlignment(
        horizontal: .left,
        vertical: .center
    )
    
    static let right = LayoutAlignment(
        horizontal: .right,
        vertical: .center
    )
    
    static let top = LayoutAlignment(
        horizontal: .center,
        vertical: .top
    )
    
    static let bottom = LayoutAlignment(
        horizontal: .center,
        vertical: .bottom
    )
    
    func center(of size: CGSize, in bounds: CGRect) -> CGPoint {
        let x = bounds.midX.addingProduct(horizontal.unitOffset, bounds.width - size.width)
        let y = bounds.midY.addingProduct(vertical.unitOffset, bounds.height - size.height)
        return CGPoint(x: x, y: y)
    }
}
