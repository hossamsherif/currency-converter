import Foundation
/*
 I. Add arithmetic operators (add, subtract, multiply, divide) to make the following expressions true. You can
 use any parentheses you’d like.
 3 1 3 9 = 12

 Solution:
 
 (- 3 + 1) * (3 - 9) = 12
*/


/*
 II. Write a function/method utilizing Swift to determine whether two strings are anagrams or not (examples
 of anagrams: debit card/bad credit, punishments/nine thumps, etc.)
 */
func solveII(str1: String, str2:String) -> Bool {
    var hash = [Character:Int]()
    let s1 = str1.filter { !$0.isWhitespace }
    let s2 = str2.filter{ !$0.isWhitespace }
    s1.forEach{ hash[$0] = 1 }
    for c in s2 {
        guard hash[c] != nil else {
            return false
        }
        hash[c] = 0
    }
    /*
     if number of character occurance matter then, this logic should be used instead
     s1.forEach{ hash[$0, default: 0] += 1 }
     s2.forEach{ hash[$0, default: 0] -= 1 }
     */
    return !hash.values.contains{ $0 != 0 }
}

solveII(str1: "punishments", str2: "nine thumps") // true
solveII(str1: "debit card", str2: "bad credit") // true
solveII(str1: "fdeg", str2: "def") // false


/*
 III. Write a method in Swift to generate the nth Fibonacci number (1, 1, 2, 3,
 5, 8, 13, 21, 34)
 A. recursive approach
 B. iterative approach
 */
func solveIIIA(n:Int) -> Int {
    guard n >= 0 else {
        assertionFailure("N mush be 0 or greater")
        return -1
    }
    var i = 0, j = 1
    for _ in 0..<n {
        let t = j
        j = i + j
        i = t
    }
    return i
}

solveIIIA(n: 7) // 13


func solveIIIB(_ f0:Int = 0, _ f1:Int = 1,n:Int) -> Int {
    guard n >= 0 else {
        assertionFailure("N mush be 0 or greater")
        return -1
    }
    if n == 0 {
        return f0
    }
    return solveIIIB(f1, f0+f1, n: n-1)
}

solveIIIB(n: 8) // 21


/*
 IV. Which architecture would you use for the required task below? Why?
 
 The architecture that I used to build the currency converter is the MVVM with reactive approach.
 The MVVM architecture would be a great candidate here for several reasons:
 - MVVM and reactive approach works well with both real time data and high rate of data transformation.
 - High testability since each layer is decoupled from the other (model, view and the viewModel) each one can be unit tested separately.
 - High reusabilty of components.
 - Relatively easy to scale and maintain.
*/


