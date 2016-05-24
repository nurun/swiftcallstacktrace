//
//  CallStackAnalyser.swift
//
//  Created by Mitch Robertson on 2016-05-20.
//  Copyright © 2016 Mitch Robertson. All rights reserved.
//

import Foundation

class CallStackAnalyser {
    
    private static func cleanMethod(method:(String)) -> String {
        if (method.characters.count > 1) {
            let firstChar:Character = method[method.startIndex]
            if (firstChar == "(") {
                return method.substringWithRange(Range<String.Index>(start: method.startIndex.advancedBy(1), end: method.endIndex.advancedBy(0)))            }
        }
        return method
    }
    
    /**
     Takes a specific item from 'NSThread.callStackSymbols()' and returns the class and method call contained within.

     - Parameter stackSymbol: a specific item from 'NSThread.callStackSymbols()'
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func classAndMethodForStackSymbol(stackSymbol:String, includeImmediateParentClass:Bool? = false) -> (String,String)? {
        let components = stackSymbol.stringByReplacingOccurrencesOfString(
            "\\s+",
            withString: " ",
            options: .RegularExpressionSearch,
            range: nil
            ).componentsSeparatedByString(" ")
    
        if (components.count >= 4) {
            var packageClassAndMethodStr = _stdlib_demangleName(components[3])
            packageClassAndMethodStr = packageClassAndMethodStr.stringByReplacingOccurrencesOfString(
                "\\s+",
                withString: " ",
                options: .RegularExpressionSearch,
                range: nil
                ).componentsSeparatedByString(" ")[0]
            
            var packageClassAndMethod = packageClassAndMethodStr.componentsSeparatedByString(".")
            let numberOfComponents = packageClassAndMethod.count
            
            if (numberOfComponents >= 2) {
                
                let method = CallStackAnalyser.cleanMethod(packageClassAndMethod[numberOfComponents-1])
                if includeImmediateParentClass != nil {
                    if (includeImmediateParentClass == true && numberOfComponents >= 4) {
                        return (packageClassAndMethod[numberOfComponents-3]+"."+packageClassAndMethod[numberOfComponents-2],method)
                    }
                }
                return (packageClassAndMethod[numberOfComponents-2],method)
            }
        }
        return nil
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the calling class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getCallingClassAndMethodInScope(includeImmediateParentClass:Bool? = false) -> (String,String)? {
        let stackSymbols = NSThread.callStackSymbols()
        if (stackSymbols.count >= 3) {
            return CallStackAnalyser.classAndMethodForStackSymbol(stackSymbols[2], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }
    
    /**
     Analyses the 'NSThread.callStackSymbols()' and returns the current class and method in the scope of the caller.
     
     - Parameter includeImmediateParentClass: Whether or not to include the parent class in an innerclass situation.
     
     - Returns: a tuple containing the (class,method) or nil if it could not be parsed
     */
    static func getThisClassAndMethodInScope(includeImmediateParentClass:Bool? = false) -> (String,String)? {
        let stackSymbols = NSThread.callStackSymbols()
        if (stackSymbols.count >= 2) {
            return CallStackAnalyser.classAndMethodForStackSymbol(stackSymbols[1], includeImmediateParentClass: includeImmediateParentClass)
        }
        return nil
    }

}
