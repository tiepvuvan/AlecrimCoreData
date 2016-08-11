//
//  DataContextCodeGenerator.swift
//  ACDGen
//
//  Created by Vanderlei Martinelli on 2016-08-11.
//  Copyright © 2016 Alecrim. All rights reserved.
//

import Foundation
import CoreData

public final class DataContextCodeGenerator: CodeGenerator {
    
    public let parameters: CodeGeneratorParameters
    
    public init(parameters: CodeGeneratorParameters) {
        self.parameters = parameters
    }

    public func generate() throws {
        //
        guard self.parameters.dataContextName != "" else { return }
        
        //
        let string = NSMutableString()
        
        //
        let className = self.parameters.dataContextName
        
        // header
        string.appendHeader(className, type: .class)
        
        // import
        string.appendLine("import Foundation")
        string.appendLine("import CoreData")
        string.appendLine()
        
        // class
        let superClassName = "NSManagedObjectContext"
        
        string.appendLine(self.parameters.accessModifier + "class \(className): \(superClassName) {")
        string.appendLine()
        string.appendLine("}")
        string.appendLine()
        
        // save
        try self.saveSourceCodeFile(withName: className, contents: string as String, type: .class)
    }
    
}
