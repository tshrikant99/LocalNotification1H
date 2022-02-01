import UIKit

var greeting = "Hello, playground"

var revString = ""

for c in greeting {
    revString = "\(c)"+revString
}
print(revString)

for i in (0...999) {

    switch i {
    case 0...9:
        print("00\(i)")
    case 10...99:
        print("0\(i)")
    case 100...999:
        print(i)
    default:
        print("NA")
    }
}

class TestSingleton {
    static let shared = TestSingleton()
    
    private init() {
        
    }
    
    func doSOme() {
        
    }
}
