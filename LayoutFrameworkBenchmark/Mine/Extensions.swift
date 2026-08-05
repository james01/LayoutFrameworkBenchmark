//
//  Extensions.swift
//  LayoutFrameworkBenchmark
//
//  Created by James Randolph on 8/4/26.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        get { CGPoint(x: midX, y: midY) }
        set {
            origin = CGPoint(
                x: newValue.x.addingProduct(-0.5, width),
                y: newValue.y.addingProduct(-0.5, height)
            )
        }
    }

    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(
            x: center.x.addingProduct(-0.5, size.width),
            y: center.y.addingProduct(-0.5, size.height)
        )
        self.init(origin: origin, size: size)
    }
}
