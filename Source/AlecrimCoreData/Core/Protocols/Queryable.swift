//
//  Queryable.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-06-17.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public protocol Queryable: Enumerable {
    
    var predicate: Predicate? { get set }
    var sortDescriptors: [SortDescriptor]? { get set }
    
}

// MARK - ordering

extension Queryable {
    
    public final func sort<A: AttributeProtocol>(using attribute: A, ascending: Bool = true) -> Self {
        return self.sort(using: attribute.___name, ascending: ascending, options: attribute.___comparisonPredicateOptions)
    }
    
    public final func sort(using attributeName: String, ascending: Bool = true, options: ComparisonPredicate.Options = DataContextOptions.defaultComparisonPredicateOptions) -> Self {
        let sortDescriptor: SortDescriptor
        
        if options.contains(.caseInsensitive) && options.contains(.diacriticInsensitive) {
            sortDescriptor = SortDescriptor(key: attributeName, ascending: ascending, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        }
        else if options.contains(.caseInsensitive) {
            sortDescriptor = SortDescriptor(key: attributeName, ascending: ascending, selector: #selector(NSString.caseInsensitiveCompare(_:)))
        }
        else if options.contains(.diacriticInsensitive) {
            sortDescriptor = SortDescriptor(key: attributeName, ascending: ascending, selector: #selector(NSString.localizedCompare(_:)))
        }
        else {
            sortDescriptor = SortDescriptor(key: attributeName, ascending: ascending)
        }
        
        return self.sort(using: sortDescriptor)
    }
    
    public final func sort(using sortDescriptor: SortDescriptor) -> Self {
        var clone = self
        
        if clone.sortDescriptors != nil {
            clone.sortDescriptors!.append(sortDescriptor)
        }
        else {
            clone.sortDescriptors = [sortDescriptor]
        }
        
        return clone
    }
    
    public final func sort(using sortDescriptors: [SortDescriptor]) -> Self {
        var clone = self

        if clone.sortDescriptors != nil {
            clone.sortDescriptors! += sortDescriptors
        }
        else {
            clone.sortDescriptors = sortDescriptors
        }
        
        return clone
    }
    
}

// MARK - filtering

extension Queryable {
    
    public final func filter(using predicate: Predicate) -> Self {
        var clone = self
        
        if let existingPredicate = clone.predicate {
            clone.predicate = CompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
        }
        else {
            clone.predicate = predicate
        }
        
        return clone
    }
    
}
