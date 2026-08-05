//
//  LayoutDynamic.swift
//  Math Flashcards
//
//  Created by James Randolph on 7/26/26.
//

import Foundation

protocol LayoutDynamic<Value> {
    associatedtype Value
    static var dependencies: LayoutContext.Dependencies { get }
    func resolved(in ctx: LayoutContext) -> Value
}

struct LayoutConstant<Value>: LayoutDynamic {
    var value: Value
    static var dependencies: LayoutContext.Dependencies { [] }
    init(_ value: Value) { self.value = value }
    func resolved(in ctx: LayoutContext) -> Value { value }
}

struct HSizeClassDependent<Value>: LayoutDynamic {
    var regular: Value
    var compact: Value
    static var dependencies: LayoutContext.Dependencies { .horizontalSizeClass }
    func resolved(in ctx: LayoutContext) -> Value {
        ctx.horizontalSizeClass == .regular ? regular : compact
    }
}
