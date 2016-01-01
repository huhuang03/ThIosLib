import UIKit
import XCTest
import ThIosLib

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDictToModel() {
        class Person : NSObject {
            var name: String?
            var age: String?
            var cat: Cat?
        }
        
        class Cat :NSObject {
            var name: String?
        }
        
        let pDict = ["name" : "zhangsan",
            "age" : "12",
        ]
        
        let p = Person.byJson(pDict)
        
        print(p)
    }
    
}
