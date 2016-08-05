//
//  AlecrimCoreDataError.swift
//  AlecrimCoreData
//
//  Created by Vanderlei Martinelli on 2015-07-25.
//  Copyright (c) 2015 Alecrim. All rights reserved.
//

import Foundation

public enum AlecrimCoreDataError: Error {
    case general
    
    case notSupported
    case notImplemented
    case notHandled

    case unexpectedValue(Any)
    
    @noreturn
    public static func handleError(_ error: Error, message: String = "Unhandled error. See callstack.") {
        // TODO:
        self.fatalError(message)
    }
    
    @noreturn
    public static func fatalError(_ message: String? = nil) {
        // TODO:
        if let message = message {
            Swift.fatalError(message)
        }
        else {
            Swift.fatalError()
        }
    }
    
}
