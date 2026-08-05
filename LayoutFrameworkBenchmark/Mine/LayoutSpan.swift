//
//  LayoutSpan.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/18/26.
//

import Foundation

struct LayoutSpan: Equatable {
    var minimum: CGFloat
    var ideal: CGFloat
    var maximum: CGFloat
    
    enum Regime {
        case compression
        case expansion
    }
    
    enum Flexibility {
        case fixed(CGFloat)
        case flexible(CGFloat, CGFloat)
    }
    
    enum Modifier {
        case constrained(min: CGFloat = 0, max: CGFloat = .infinity)
        case flexible
        case greedy
    }
    
    static let zero = LayoutSpan(min: 0, ideal: 0, max: 0)
    
    init(min: CGFloat, ideal: CGFloat, max: CGFloat) {
        self.minimum = min
        self.ideal = ideal
        self.maximum = max
    }
    
    static func fixed(_ value: CGFloat) -> LayoutSpan {
        return LayoutSpan(min: value, ideal: value, max: value)
    }
    
    static func flexible(min: CGFloat = 0, max: CGFloat = .infinity) -> LayoutSpan {
        return LayoutSpan(min: min, ideal: min, max: max)
    }
    
    static func greedy(min: CGFloat = 0, max: CGFloat = .infinity) -> LayoutSpan {
        return LayoutSpan(min: min, ideal: max, max: max)
    }
    
    func resolved(for available: CGFloat) -> CGFloat {
        return min(max(available, minimum), maximum)
    }
    
    func flexibility(in regime: Regime) -> Flexibility {
        switch regime {
        case .compression:
            if minimum == ideal {
                return .fixed(minimum)
            } else {
                return .flexible(minimum, ideal)
            }
        case .expansion:
            if ideal == maximum {
                return .fixed(ideal)
            } else {
                return .flexible(ideal, maximum)
            }
        }
    }
    
    func applying(_ modifier: Modifier) -> LayoutSpan {
        switch modifier {
        case .constrained(let lo, let hi):
            return LayoutSpan(
                min: min(max(minimum, lo), hi),
                ideal: min(max(ideal, lo), hi),
                max: min(max(maximum, lo), hi)
            )
        case .flexible:
            return LayoutSpan(min: minimum, ideal: ideal, max: .infinity)
        case .greedy:
            return LayoutSpan(min: minimum, ideal: .infinity, max: .infinity)
        }
    }
}

// MARK: Arithmetic

extension LayoutSpan {
    static func + (lhs: LayoutSpan, rhs: LayoutSpan) -> LayoutSpan {
        return LayoutSpan(
            min: lhs.minimum + rhs.minimum,
            ideal: lhs.ideal + rhs.ideal,
            max: lhs.maximum + rhs.maximum
        )
    }
    
    static func += (lhs: inout LayoutSpan, rhs: LayoutSpan) {
        lhs.minimum += rhs.minimum
        lhs.ideal += rhs.ideal
        lhs.maximum += rhs.maximum
    }
    
    static func + (lhs: LayoutSpan, rhs: CGFloat) -> LayoutSpan {
        return LayoutSpan(
            min: lhs.minimum + rhs,
            ideal: lhs.ideal + rhs,
            max: lhs.maximum + rhs
        )
    }
    
    static func += (lhs: inout LayoutSpan, rhs: CGFloat) {
        lhs.minimum += rhs
        lhs.ideal += rhs
        lhs.maximum += rhs
    }
    
    func addingProduct(_ lhs: CGFloat, _ rhs: CGFloat) -> LayoutSpan {
        return LayoutSpan(
            min: minimum.addingProduct(lhs, rhs),
            ideal: ideal.addingProduct(lhs, rhs),
            max: maximum.addingProduct(lhs, rhs)
        )
    }
    
    mutating func addProduct(_ lhs: CGFloat, _ rhs: CGFloat) {
        minimum.addProduct(lhs, rhs)
        ideal.addProduct(lhs, rhs)
        maximum.addProduct(lhs, rhs)
    }
    
    mutating func formMax(_ other: LayoutSpan) {
        minimum = max(minimum, other.minimum)
        ideal = max(ideal, other.ideal)
        maximum = max(maximum, other.maximum)
    }
}
