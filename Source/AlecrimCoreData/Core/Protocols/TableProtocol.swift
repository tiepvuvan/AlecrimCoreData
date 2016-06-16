//
//  TableProtocol.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-06-17.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public protocol TableProtocol: CoreDataQueryable {
    
}

// MARK: - create, delete and refresh entities

extension TableProtocol where Self.Element: NSManagedObject {
    
    public final func createEntity() -> Self.Element {
        return Self.Element(entity: self.entityDescription, insertInto: self.dataContext)
    }

    public final func delete(_ entity: Self.Element) {
        self.dataContext.delete(entity)
    }
    
    public final func refresh(_ entity: Self.Element, mergeChanges: Bool = true) {
        self.dataContext.refresh(entity, mergeChanges: mergeChanges)
    }

}

extension TableProtocol {
    
    public final func deleteEntities() throws {
        let fetchRequest = self.toFetchRequest() as NSFetchRequest<NSManagedObjectID>
        fetchRequest.resultType = .managedObjectIDResultType
        
        let objectIDs = try self.dataContext.fetch(fetchRequest)
        
        for objectID in objectIDs {
            let object = try self.dataContext.existingObject(with: objectID)
            self.dataContext.delete(object)
        }
    }

}

extension TableProtocol where Self.Element: NSManagedObject {
    
    public final func firstOrCreated(_ predicateClosure: @noescape (Self.Element.Type) -> ComparisonPredicate) -> Self.Element {
        let predicate = predicateClosure(Self.Element.self)
        
        if let entity = self.filter(using: predicate).first() {
            return entity
        }
        else {
            let entity = self.createEntity()
            
            let attributeName = predicate.leftExpression.keyPath
            let value: AnyObject = predicate.rightExpression.constantValue!
            
            (entity as NSManagedObject).setValue(value, forKey: attributeName)
            
            return entity
        }
    }

}


// MARK: - GenericQueryable

extension TableProtocol {
    
    public final func toArray() -> [Self.Element] {
        do {
            var results: [Self.Element] = []
            
            let objects = try self.dataContext.fetch(self.toFetchRequest())
            
            if let entities = objects as? [Self.Element] {
                results += entities
            }
            else {
                // HAX: the previous cast may not work in certain circumstances
                try objects.forEach {
                    guard let entity = $0 as? Self.Element else { throw AlecrimCoreDataError.unexpectedValue($0) }
                    results.append(entity)
                }
            }
            
            return results
        }
        catch let error {
            AlecrimCoreDataError.handleError(error)
        }
    }
    
}

// MARK: - CoreDataQueryable

extension TableProtocol {
    
    public final func toFetchRequest<ResultType: NSFetchRequestResult>() -> NSFetchRequest<ResultType> {
        let fetchRequest = NSFetchRequest<ResultType>()
        
        fetchRequest.entity = self.entityDescription
        
        fetchRequest.fetchOffset = self.offset
        fetchRequest.fetchLimit = self.limit
        fetchRequest.fetchBatchSize = (self.limit > 0 && self.batchSize > self.limit ? 0 : self.batchSize)
        
        fetchRequest.predicate = self.predicate
        fetchRequest.sortDescriptors = self.sortDescriptors
        
        return fetchRequest
    }
    
}

