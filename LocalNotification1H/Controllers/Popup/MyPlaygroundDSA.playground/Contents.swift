import UIKit

var greeting = "Hello, playground"

// *****************************  DSA *****************************
// >>>>>>>>>>>>>>>>>>>  Array based   <<<<<<<<<<<<<<<<<<<<<<<<

//// find second large no
//let arr = [50,1,2,10,8,7,4,20, 52, 51]
//
//var maxNo = 0, secMaxNo = 0
//for i in arr {
//    if maxNo < i {
//        secMaxNo = maxNo
//        maxNo = i
//        print("Now max is > \(maxNo)")
//    } else {
//        if secMaxNo < i {
//            secMaxNo = i
//        }
//        print("Now sec max is > \(secMaxNo)")
//    }
//}
//print("max \(maxNo) & sec max \(secMaxNo)")

//// Merge two array & sort
//let a1 = [1,8], a2 = [3,5,6]
//
//var c = a1 + a2
//c.sort()
//print("After merge & sorted \(c)")


////Sorting algo
//// selection sort
//func selectionSort(arr: inout [Int]) -> [Int] {
//
//    for i in 0..<arr.count-1 {
//        var minIndex = i
//        print("@ min index \(minIndex)")
//
//        for j in i+1..<arr.count {
//
//            print("@ j index \(j)")
//
//            if arr[j] < arr[minIndex] {
//                minIndex = j
//            }
//        }
//        arr.swapAt(i, minIndex)
//
//        print("now arr > `\(arr)")
//    }
//
//    return arr
//}
//var a = [10,5,3,15,20,4]
//let nwArr = selectionSort(arr: &a)


//// Find max consecutive 1's from binary array   (O(n))
//func findConsecutiveNumber(arr: [Int]) -> Int {
//    var localCount = 0 , globalcount = 0
//
//    for no in arr {
//        if no == 1 {
//            localCount += 1
//
//            globalcount = max(localCount, globalcount)
//        } else {
//            localCount = 0
//        }
//    }
//    return globalcount
//}
//print("Max consecutive 1's : \(findConsecutiveNumber(arr: [1,1,0,0,1,1,1,0]))")


//// Find Majority element in array
//func findMajorityElement(arr: [Int]) -> Int {
//    var firstNo = arr[0]
//    var counter = 0
//    for no in arr {
//        if no == firstNo {
//            counter += 1
//        } else {
//            counter -= 1
//        }
//
//        if counter == 0 {
//            firstNo = no
//            counter = 1
//        }
//    }
//    print("counter is \(counter)")
//    return firstNo
//}
//print("Majority no : \(findMajorityElement(arr: [1,1,0,0,0,1,0,0]))")


//// Find unique intersection of two arrays
//func findUniqueIntersectionElement(arr1: [Int], arr2: [Int]) -> [Int] {
//    var set1 = Set<Int>()
//    var set2 = Set<Int>()
//
//    for n1 in arr1 {
//        set1.insert(n1)
//    }
//
//    for n2 in arr2 {
//        set2.insert(n2)
//    }
//
//    return Array(set1.intersection(set2))
//
//}
//print("Unique Intersection in arrays : \(findUniqueIntersectionElement(arr1: [2,3,1,0], arr2: [1,4,5,0]))")


//// Find Duplicate element arrays
//func findDuplicateElement(arr: [Int]) -> (Bool, Set<Int>) {
//
//    var dict = [Int : Int]()
//    var duplicateElemts = Set<Int>()
//    for no in arr {
//        if dict[no] != nil {
//            duplicateElemts.insert(no)
//        } else {
//            dict[no] = no
//        }
//    }
//
//    return (!duplicateElemts.isEmpty , duplicateElemts)
//}
//print("Duplicate element found in arrays : \(findDuplicateElement(arr: [1,2,3,4,2,4,2]))")


////Find unique elements from array
//func findUniqueElementsFromArray(arr: inout [Int]) -> (Int, [Int]) {
//    var index = 0
//
//    for item in arr {
//        if item != arr[index] {
//            index += 1
//            arr[index] = item
//        }
//    }
//    return (index, arr)
//}
//var myArr = [0,1,2,2,2,3]
//let resultTuple = findUniqueElementsFromArray(arr: &myArr)
//print("index > \(resultTuple.0)")
//for i in 0...resultTuple.0 {
//    print("Array is >> \(resultTuple.1[i])")
//}


////Move zeros to the end of array
//func moveZerosToTheEndOfArray(arr: inout [Int]) -> [Int] {
//    var index = 0
//
//    for no in arr {
//        if no != 0 {
//            arr[index] = no
//            index += 1
//        }
//    }
//
//    for i in index..<arr.count {
//        arr[i] = 0
//    }
//
//    return arr
//}
//var myArr = [1,2,0,0,2,0,3,5,0,0,1,0]
//print("Array after moving zeros to end >> \(moveZerosToTheEndOfArray(arr: &myArr))")



// >>>>>>>>>>>>>>>>>>>  String based   <<<<<<<<<<<<<<<<<<<<<<<<

//// FiZZ BuZZ : Write 1...n & multiple of 3 = fizz , multiple of 5 = buzz & multiple of both = fizz buzz
//func fizzBuzz(maxNo: Int, fizzNo: Int, buzzNo: Int) {
//    let multipliedNo = fizzNo * buzzNo
//
//    for i in 1...maxNo {
//        if (i % multipliedNo == 0) {
//            print("FIzz BuzZ")
//        } else if (i % fizzNo == 0) {
//            print("FiZz")
//        } else if (i % buzzNo == 0) {
//            print("BuzZ")
//        } else {
//            print(i)
//        }
//    }
//}
//fizzBuzz(maxNo: 20, fizzNo: 4, buzzNo: 5)


//// Palindrome string
//func checkPalindromString(inputString: String) {
//    var revStr = ""
//
//    for c in inputString {
//        revStr = "\(c)" + revStr
//    }
//
//    if inputString == revStr {
//        print("String is palindrome")
//    } else {
//        print("String is not palindrome")
//    }
//}
//checkPalindromString(inputString: "ICICI")


// GEt first unique element in String
func findFirstUniqueElement(inputString: inout String) {

    inputString = inputString.lowercased()

    var dictString = [Character : Bool]()

    for char in inputString {
        if dictString[char] != nil {
            dictString[char] = false
        } else {
            dictString[char] = true
        }
    }

    for (index, char) in inputString.enumerated() {
        if dictString[char] == true {
            print("FIrst index \(index) & char \(char)")
            return
        }
    }
}
var str = "SHrihS"
findFirstUniqueElement(inputString: &str)


//// >> Get unique chars of string
///
//let name = "shrinivas"
//
//func getUniqueString(name: String) -> String {
//    var unq = ""
//
//    for c in name {
//        if unq.contains(c) {
//            continue
//        } else {
//            unq.append(c)
//        }
//    }
//    return unq
//
//}
//var newName = getUniqueString(name: name)
//print("Uniq char array > \(newName) ")
//let str = newName.reduce("", { partialResult, c in
//    return partialResult+String(c)
//})
//print("Uniq str > \(str) ")

//// >> Remove white spaces
//
//func getWhiteSpacedString(inputString: String) -> String {
//    var flag = false
//    var outputString = ""
//    for c in inputString {
//        if c == " " {
//            if flag {
//                continue
//            }
//            flag = true
//        } else {
//            flag = false
//        }
//        outputString.append(c)
//    }
//    return outputString
//}
//
//let newS = getWhiteSpacedString(inputString: "Hey i am shri  and you r my   enemy")
//print("After remove white space  > \(newS) ")

//// >> Get alphabet count in string

//func getAlphabetCont(name: String) -> Int {
//    let setName = Set(name)
//    let letters = setName.filter { $0 >= "a" && $0 <= "z" }
//    print("letters \(letters)")
//    return letters.count
//}
//let namee = "shreee99 hi 10"
//print(" Get alphabet count form \(namee) \(getAlphabetCont(name: namee))")

//// >>  Reverese string
//let str = "shrikant"
//
//var rev = ""
//for c in str {
//    rev = "\(c)"+rev
//}
//print("Rev \(rev)")


