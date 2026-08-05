//
//  StackHelper.swift
//  Math Flashcards
//
//  Created by James Randolph on 6/24/26.
//

import Foundation

enum StackHelper {

    struct Distribution {
        var regime: LayoutSpan.Regime
        var share: CGFloat
        var contentLength: CGFloat
        
        func resolvedShare(for span: LayoutSpan) -> CGFloat {
            switch span.flexibility(in: regime) {
            case .fixed(let v):
                return v
            case .flexible(let lo, let hi):
                return min(max(share, lo), hi)
            }
        }
    }

    static func totalSpan<each P>(
        of spans: (repeat Per<each P, LayoutSpan>),
        spacing: CGFloat
    ) -> LayoutSpan {
        var total = LayoutSpan.zero
        var count: CGFloat = 0
        for span in repeat each spans {
            total += span.value
            count += 1
        }
        total.addProduct(spacing, max(count - 1, 0))
        return total
    }

    static func maxSpan<each P>(
        of spans: (repeat Per<each P, LayoutSpan>)
    ) -> LayoutSpan {
        var result = LayoutSpan.zero
        for span in repeat each spans {
            result.formMax(span.value)
        }
        return result
    }

    static func distribution<each P>(
        of spans: (repeat Per<each P, LayoutSpan>),
        fitting length: CGFloat,
        spacing: CGFloat
    ) -> Distribution {
        var totalIdeal: CGFloat = 0
        var count: CGFloat = 0
        for span in repeat each spans {
            totalIdeal += span.value.ideal
            count += 1
        }
        let totalSpacing = spacing * max(count - 1, 0)
        let available = length - totalSpacing
        let regime: LayoutSpan.Regime
        if available < totalIdeal {
            regime = .compression
        } else {
            regime = .expansion
        }
        
        var totalFixed: CGFloat = 0
        var flexMin: CGFloat = 0
        var flexMax: CGFloat = 0
        var next: CGFloat = .infinity
        for span in repeat each spans {
            switch span.value.flexibility(in: regime) {
            case .fixed(let v):
                totalFixed += v
            case .flexible(let lo, let hi):
                flexMin += lo
                flexMax += hi
                next = min(next, lo)
            }
        }

        let flexAvailable = available - totalFixed

        let share: CGFloat
        if flexAvailable <= flexMin {
            share = 0
        } else if flexAvailable >= flexMax {
            share = .infinity
        } else {
            var level: CGFloat = 0
            var slope: CGFloat = 0
            var total: CGFloat = 0
            repeat {
                level = next
                slope = 0
                next = .infinity
                total = 0
                for span in repeat each spans {
                    let flexibility = span.value.flexibility(in: regime)
                    if case .flexible(let lo, let hi) = flexibility {
                        if level < lo {
                            total += lo
                            next = min(next, lo)
                        } else if level < hi {
                            total += level
                            slope += 1
                            next = min(next, hi)
                        } else {
                            total += hi
                        }
                    }
                }
            } while total.addingProduct(slope, next - level) < flexAvailable
            share = slope > 0 ? level + (flexAvailable - total) / slope : level
        }

        let totalFlex = min(max(flexAvailable, flexMin), flexMax)
        let total = totalSpacing + totalFixed + totalFlex
        return Distribution(regime: regime, share: share, contentLength: total)
    }
}
