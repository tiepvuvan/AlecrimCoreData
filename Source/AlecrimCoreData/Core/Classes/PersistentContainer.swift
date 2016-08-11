//
//  PersistentContainer.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2016-06-20.
//  Copyright © 2016 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public struct PersistentContainerOptions {
    public static var defaultBatchSize: Int = 20
    public static var defaultComparisonPredicateOptions: NSComparisonPredicate.Options = [.caseInsensitive, .diacriticInsensitive]
}

public class PersistentContainer<T: NSManagedObjectContext> {

    // MARK: -

    public class func defaultDirectoryURL() -> URL { return NSPersistentContainer.defaultDirectoryURL() }
    

    // MARK: -

    public let underlyingPersistentContainer: NSPersistentContainer
    
    // MARK: -
    
    public var name: String { return self.underlyingPersistentContainer.name }
    
    public var viewContext: T { return self.underlyingPersistentContainer.viewContext as! T }
    
    public var managedObjectModel: NSManagedObjectModel { return self.underlyingPersistentContainer.managedObjectModel }
    
    public var persistentStoreCoordinator: NSPersistentStoreCoordinator { return self.underlyingPersistentContainer.persistentStoreCoordinator }
    
    public var persistentStoreDescriptions: [NSPersistentStoreDescription] {
        get {
            return self.underlyingPersistentContainer.persistentStoreDescriptions
        }
        set {
            self.underlyingPersistentContainer.persistentStoreDescriptions = newValue
        }
    }
    
    // MARK: -
    
    public init(name: String) {
        self.underlyingPersistentContainer = NSPersistentContainer(name: name)
        PersistentContainer.configureManagedObjectContext(self.viewContext)
    }
    
    
    public init(name: String, managedObjectModel model: NSManagedObjectModel) {
        self.underlyingPersistentContainer = NSPersistentContainer(name: name, managedObjectModel: model)
        PersistentContainer.configureManagedObjectContext(self.viewContext)
    }
    
    // MARK: -
    
    public func loadPersistentStores(completionHandler block: (NSPersistentStoreDescription, Error?) -> Swift.Void) {
        self.underlyingPersistentContainer.loadPersistentStores(completionHandler: block)
    }
    
    public func newBackgroundContext() -> T {
        return self.underlyingPersistentContainer.newBackgroundContext() as! T
    }
    
    public func performBackgroundTask(_ block: (T) -> Swift.Void) {
        self.underlyingPersistentContainer.performBackgroundTask { backgroundContext in
            PersistentContainer.configureManagedObjectContext(backgroundContext)
            block(backgroundContext as! T)
        }
    }
    
    // MARK: -
    
    private static func configureManagedObjectContext(_ context: NSManagedObjectContext) {
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
}
