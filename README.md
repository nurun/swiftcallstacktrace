# swiftcallstacktrace
This is a utility class for parsing the current call stack in scope. This can be very useful for logging so that you automatically prefix logs with code contextual information.

Here is a code sample that utilises the CallStackAnalyser with comments indicating the output.
```swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let innerClass = MyInnerClass()
        innerClass.publicInsideInnerClass()
    }
    
    class MyInnerClass {
        
        func publicInsideInnerClass() {
            anotherMethodInsideInnerClass()
        }
        
        private func anotherMethodInsideInnerClass() {

            let thisMethodInfo = CallStackAnalyser.getThisClassAndMethodInScope(true)
            
            if let thisMethodInfo = thisMethodInfo {
                NSLog("class: %@", thisMethodInfo.0)
                NSLog("method: %@", thisMethodInfo.1)
                
                /*
                class: ViewController.MyInnerClass
                method: anotherMethodInsideInnerClass
                */
            }
            
            let callingMethodInfo = CallStackAnalyser.getCallingClassAndMethodInScope(false)
            
            if let callingMethodInfo = callingMethodInfo {
                NSLog("class: %@", callingMethodInfo.0)
                NSLog("method: %@", callingMethodInfo.1)
                
                /*
                class: MyInnerClass
                method: publicInsideInnerClass
                */
            }
            
            // NB: passing 'true' for 'includeImmediateParentClass' would return the same thing since 'ViewController' is not an inner class
            let originalMethodInfo = CallStackAnalyser.classAndMethodForStackSymbol(NSThread.callStackSymbols()[2])
            
            if let originalMethodInfo = originalMethodInfo {
                NSLog("class: %@", originalMethodInfo.0)
                NSLog("method: %@", originalMethodInfo.1)
                
                /*
                class: ViewController
                method: viewDidLoad
                */
            }
        }
    }
}
```
