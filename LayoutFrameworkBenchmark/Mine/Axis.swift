//
//  Axis.swift
//  Math Flashcards
//
//  Created by James Randolph on 4/28/26.
//

import Foundation

enum Axis {
    case horizontal
    case vertical
    
    struct Set: OptionSet {
        let rawValue: Int
        
        static let horizontal = Set(rawValue: 1 << 0)
        static let vertical = Set(rawValue: 1 << 1)
        
        static let all: Set = [.horizontal, .vertical]
    }
}

// MARK: CGSize

extension  CGSize {
    func main(for axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: width
        case .vertical: height
        }
    }
    
    func cross(for axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: height
        case .vertical: width
        }
    }
    
    init(main: CGFloat, cross: CGFloat, axis: Axis) {
        switch axis {
        case .horizontal: self.init(width: main, height: cross)
        case .vertical: self.init(width: cross, height: main)
        }
    }
}

// MARK: CGPoint

extension CGPoint {
    func main(for axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: x
        case .vertical: y
        }
    }
    
    func cross(for axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: y
        case .vertical: x
        }
    }
    
    init(main: CGFloat, cross: CGFloat, axis: Axis) {
        switch axis {
        case .horizontal: self.init(x: main, y: cross)
        case .vertical: self.init(x: cross, y: main)
        }
    }
}
