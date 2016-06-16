//
//  GenericQueryable.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-07-25.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation

public protocol GenericQueryable: Queryable {
    
    associatedtype Element = Self.Iterator.Element
    
    func toArray() -> [Self.Element]

}

// MARK: - ordering

extension GenericQueryable {
    
    public final func orderBy<A: AttributeProtocol, V where A.ValueType == V>(_ ascending: Bool = true, orderingClosure: @noescape (Self.Element.Type) -> A) -> Self {
        return self.sort(using: orderingClosure(Self.Element.self), ascending: ascending)
    }
    
}

// MARK: - filtering

extension GenericQueryable {
    
    public final func filter(_ predicateClosure: @noescape (Self.Element.Type) -> Predicate) -> Self {
        return self.filter(using: predicateClosure(Self.Element.self))
    }
    
}

// MARK: -

extension GenericQueryable {
    
    public final func count(_ predicateClosure: @noescape (Self.Element.Type) -> Predicate) -> Int {
        return self.filter(using: predicateClosure(Self.Element.self)).count()
    }
    
}

extension GenericQueryable {
    
    public final func any(_ predicateClosure: @noescape (Self.Element.Type) -> Predicate) -> Bool {
        return self.filter(using: predicateClosure(Self.Element.self)).any()
    }
    
    public final func none(_ predicateClosure: @noescape (Self.Element.Type) -> Predicate) -> Bool {
        return self.filter(using: predicateClosure(Self.Element.self)).none()
    }
    
}

extension GenericQueryable {
    
    public final func first(_ predicateClosure: @noescape (Self.Element.Type) -> Predicate) -> Self.Element? {
        return self.filter(using: predicateClosure(Self.Element.self)).first()
    }
    
}

// MARK: - entity

extension GenericQueryable {
    
    public final func first() -> Self.Element? {
        return self.take(1).toArray().first
    }
    
}


//// TODO: this still crashes the compiler - Xcode 7.3.1
//// MARK: - SequenceType
//
////extension GenericQueryable {
////    
////    public typealias Generator = AnyGenerator<Self.Element>
////    
////    public func generate() -> AnyGenerator<Self.Element> {
////        return AnyGenerator(self.toArray().generate())
////    }
////    
////}
//
//extension Table: SequenceType {
//
//    public typealias Generator = AnyGenerator<T>
//
//    public func generate() -> Generator {
//        return AnyGenerator(self.toArray().generate())
//    }
//    
//    // turns the SequenceType implementation unavailable
//    @available(*, unavailable)
//    public func filter(@noescape includeElement: (Table.Generator.Element) throws -> Bool) rethrows -> [Table.Generator.Element] {
//        return []
//    }
//    
//}
//
//extension AttributeQuery: SequenceType {
//    
//    public typealias Generator = AnyGenerator<T>
//    
//    public func generate() -> Generator {
//        return AnyGenerator(self.toArray().generate())
//    }
//
//    // turns the SequenceType implementation unavailable
//    @available(*, unavailable)
//    public func filter(@noescape includeElement: (AttributeQuery.Generator.Element) throws -> Bool) rethrows -> [AttributeQuery.Generator.Element] {
//        return []
//    }
//
//}
//
