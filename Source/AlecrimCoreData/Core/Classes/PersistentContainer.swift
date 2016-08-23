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

// FIXME: this class is using a lot of unsafe bit casts to provide generic support (errors can occur if the derived managed object class add stored properties or new methods)

public class PersistentContainer<T: NSManagedObjectContext> {

    // MARK: -

    public class func defaultDirectoryURL() -> URL { return NSPersistentContainer.defaultDirectoryURL() }
    

    // MARK: -

    public let underlyingPersistentContainer: NSPersistentContainer
    
    // MARK: -
    
    public var name: String { return self.underlyingPersistentContainer.name }
    
    public var viewContext: T { return unsafeBitCast(self.underlyingPersistentContainer.viewContext, to: T.self) }
    
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
    
    public func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Swift.Void) {
        self.underlyingPersistentContainer.loadPersistentStores(completionHandler: block)
    }
    
    public func newBackgroundContext() -> T {
        return unsafeBitCast(self.underlyingPersistentContainer.newBackgroundContext(), to: T.self)
    }
    
    public func performBackgroundTask(_ block: @escaping (T) -> Swift.Void) {
        self.underlyingPersistentContainer.performBackgroundTask { backgroundContext in
            PersistentContainer.configureManagedObjectContext(backgroundContext)
            block(unsafeBitCast(backgroundContext, to: T.self))
        }
    }
    
    // MARK: -
    
    private static func configureManagedObjectContext(_ context: NSManagedObjectContext) {
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
}
