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
    
    func execute() -> [Self.Element]

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
        return self.take(1).execute().first
    }
    
}

// MARK: - Sequence

extension GenericQueryable {
    
    public final func makeIterator() -> AnyIterator<Self.Element> {
        return AnyIterator(self.execute().makeIterator())
    }
    
}
