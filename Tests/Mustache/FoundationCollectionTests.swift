// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import XCTest
import Mustache
import Foundation

// TODO: write an equivalent test class for Swift collections
class FoundationCollectionTests: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    var allTests : [(String, () throws -> Void)] {
        return [
            ("testNSArrayIsIterated", testNSArrayIsIterated),
            ("testNSArrayIsNotIteratedWithValueForKey", testNSArrayIsNotIteratedWithValueForKey),
            ("testNSArrayIsEmpty", testNSArrayIsEmpty),
            ("testNSArrayCountKey", testNSArrayCountKey),
            ("testNSArrayKeyFirst", testNSArrayKeyFirst),
            ("testNSArrayLastKey", testNSArrayLastKey),
            ("testArrayIsIterated", testArrayIsIterated),
            ("testArrayIsNotIteratedWithValueForKey", testArrayIsNotIteratedWithValueForKey),
            ("testArrayIsEmpty", testArrayIsEmpty),
            ("testArrayCountKey", testArrayCountKey),
            ("testArrayKeyFirst", testArrayKeyFirst),
            ("testArrayLastKey", testArrayLastKey),
            ("testNSSetIsIterated", testNSSetIsIterated),
            ("testNSSetIsNotIteratedWithValueForKey", testNSSetIsNotIteratedWithValueForKey),
            ("testNSSetIsEmpty", testNSSetIsEmpty),
            ("testNSSetCountKey", testNSSetCountKey),
            ("testNSSetFirstKey", testNSSetFirstKey),
            ("testNSSetLastKey", testNSSetLastKey),
            ("testSetIsIterated", testSetIsIterated),
            ("testSetIsNotIteratedWithValueForKey", testSetIsNotIteratedWithValueForKey),
            ("testSetIsEmpty", testSetIsEmpty),
            ("testSetCountKey", testSetCountKey),
            ("testSetFirstKey", testSetFirstKey),
            ("testSetLastKey", testSetLastKey),
            ("testNSOrderedSetIsIterated", testNSOrderedSetIsIterated),
            ("testNSOrderedSetIsNotIteratedWithValueForKey", testNSOrderedSetIsNotIteratedWithValueForKey),
            ("testNSOrderedSetCountKey", testNSOrderedSetCountKey),
            ("testNSOrderedSetKeyFirst", testNSOrderedSetKeyFirst),
            ("testNSOrderedSetLastKey", testNSOrderedSetLastKey),
        ]
    }
// END OF GENERATED CODE
    
    var boxedArray: MustacheBox!
    var boxedNSArray: MustacheBox!
    var boxedSet: MustacheBox!
    var boxedNSSet: MustacheBox!
    var boxedNSOrderedSet: MustacheBox!

    #if os(Linux) //fix until swift snapshot of 16-th of March 2016
        func setUp() {
            doSetUp()
        }
    #else
        override func setUp() {
            doSetUp()
        }
    #endif

    func doSetUp() {
        boxedArray = Box(["collection": [["key": "value"]]])
        boxedNSArray = {
            let array = NSMutableArray()
            array.add(["key": "value"].bridge())
            let data = NSMutableDictionary()
            data.setObject(array, forKey: "collection".bridge())
            return Box(data)
        }()
        boxedSet = {
            let object = NSDictionary(objects: [NSString(string: "value")], forKeys: [NSString(string:"key")])
            return Box(["collection": Set([object])])
        }()
        boxedNSSet = {
            let set = NSMutableSet()
            set.add(["key": "value"].bridge())
            let data = NSMutableDictionary()
            data.setObject(set, forKey: "collection".bridge())
            return Box(data)
            }()
        boxedNSOrderedSet = {
            let orderedSet = NSMutableOrderedSet()
            orderedSet.add(["key": "value"].bridge())
            let data = NSMutableDictionary()
            data.setObject(orderedSet, forKey: "collection".bridge())
            return Box(data)
            }()
    }
    
    func testNSArrayIsIterated() {
        let rendering = try! Template(string: "{{#collection}}{{key}}{{/collection}}").render(with: boxedNSArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSArrayIsNotIteratedWithValueForKey() {
        let rendering = try! Template(string: "{{#collection.key}}{{.}}{{/collection.key}}").render(with: boxedNSArray)
        XCTAssertEqual(rendering, "")
    }
    
    func testNSArrayIsEmpty() {
        // Arrays can NOT be queried for the key `isEmpty` on purpose.
        // This test makes sure no user request would activate such a bad idea.
        //
        // `array.isEmpty` would evaluate to false in case of a missing set, and
        // this would be soooo misleading. On the contrary, `array.count` is
        // falsey for both empty and missing sets, and this is why it is the
        // recommended technique.
        let templateString = "{{#collection.isEmpty}}Empty{{/}}{{^collection.isEmpty}}Not empty{{/}}"
        XCTAssertEqual(try! Template(string: templateString).render(), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":NSArray()])), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":NSArray(object: "foo".bridge())])), "Not empty")
    }
    
    func testNSArrayCountKey() {
        let rendering = try! Template(string: "{{collection.count}}").render(with: boxedNSArray)
        XCTAssertEqual(rendering, "1")
    }
    
    func testNSArrayKeyFirst() {
        let rendering = try! Template(string: "{{collection.first.key}}").render(with: boxedNSArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSArrayLastKey() {
        let rendering = try! Template(string: "{{collection.last.key}}").render(with: boxedNSArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testArrayIsIterated() {
        let rendering = try! Template(string: "{{#collection}}{{key}}{{/collection}}").render(with: boxedArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testArrayIsNotIteratedWithValueForKey() {
        let rendering = try! Template(string: "{{#collection.key}}{{.}}{{/collection.key}}").render(with: boxedArray)
        XCTAssertEqual(rendering, "")
    }
    
    func testArrayIsEmpty() {
        // Arrays can NOT be queried for the key `isEmpty` on purpose.
        // This test makes sure no user request would activate such a bad idea.
        //
        // `array.isEmpty` would evaluate to false in case of a missing set, and
        // this would be soooo misleading. On the contrary, `array.count` is
        // falsey for both empty and missing sets, and this is why it is the
        // recommended technique.
        let templateString = "{{#collection.isEmpty}}Empty{{/}}{{^collection.isEmpty}}Not empty{{/}}"
        XCTAssertEqual(try! Template(string: templateString).render(), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection": [Any]()])), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":["foo"]])), "Not empty")
    }
    
    func testArrayCountKey() {
        let rendering = try! Template(string: "{{collection.count}}").render(with: boxedArray)
        XCTAssertEqual(rendering, "1")
    }
    
    func testArrayKeyFirst() {
        let rendering = try! Template(string: "{{collection.first.key}}").render(with: boxedArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testArrayLastKey() {
        let rendering = try! Template(string: "{{collection.last.key}}").render(with: boxedArray)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSSetIsIterated() {
        let rendering = try! Template(string: "{{#collection}}{{key}}{{/collection}}").render(with: boxedNSSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSSetIsNotIteratedWithValueForKey() {
        let rendering = try! Template(string: "{{#collection.key}}{{.}}{{/collection.key}}").render(with: boxedNSSet)
        XCTAssertEqual(rendering, "")
    }
    
    func testNSSetIsEmpty() {
        // Sets can NOT be queried for the key `isEmpty` on purpose.
        // This test makes sure no user request would activate such a bad idea.
        //
        // `set.isEmpty` would evaluate to false in case of a missing set, and
        // this would be soooo misleading. On the contrary, `set.count` is
        // falsey for both empty and missing sets, and this is why it is the
        // recommended technique.
        let templateString = "{{#collection.isEmpty}}Empty{{/}}{{^collection.isEmpty}}Not empty{{/}}"
        XCTAssertEqual(try! Template(string: templateString).render(), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":NSSet()])), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":NSSet(object: "foo".bridge())])), "Not empty")
    }
    
    func testNSSetCountKey() {
        let rendering = try! Template(string: "{{collection.count}}").render(with: boxedNSSet)
        XCTAssertEqual(rendering, "1")
    }
    
    func testNSSetFirstKey() {
        let rendering = try! Template(string: "{{collection.first.key}}").render(with: boxedNSSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSSetLastKey() {
        // There is no such thing as set.last
        let rendering = try! Template(string: "{{collection.last.key}}").render(with: boxedNSSet)
        XCTAssertEqual(rendering, "")
    }
    
    func testSetIsIterated() {
        let rendering = try! Template(string: "{{#collection}}{{key}}{{/collection}}").render(with: boxedSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testSetIsNotIteratedWithValueForKey() {
        let rendering = try! Template(string: "{{#collection.key}}{{.}}{{/collection.key}}").render(with: boxedSet)
        XCTAssertEqual(rendering, "")
    }
    
    func testSetIsEmpty() {
        // Sets can NOT be queried for the key `isEmpty` on purpose.
        // This test makes sure no user request would activate such a bad idea.
        //
        // `set.isEmpty` would evaluate to false in case of a missing set, and
        // this would be soooo misleading. On the contrary, `set.count` is
        // falsey for both empty and missing sets, and this is why it is the
        // recommended technique.
        let templateString = "{{#collection.isEmpty}}Empty{{/}}{{^collection.isEmpty}}Not empty{{/}}"
        XCTAssertEqual(try! Template(string: templateString).render(), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":Set<String>()])), "Not empty")
        XCTAssertEqual(try! Template(string: templateString).render(with: Box(["collection":Set(["foo"])])), "Not empty")
    }
    
    func testSetCountKey() {
        let rendering = try! Template(string: "{{collection.count}}").render(with: boxedSet)
        XCTAssertEqual(rendering, "1")
    }
    
    func testSetFirstKey() {
        let rendering = try! Template(string: "{{collection.first.key}}").render(with: boxedSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testSetLastKey() {
        // There is no such thing as set.last
        let rendering = try! Template(string: "{{collection.last.key}}").render(with: boxedSet)
        XCTAssertEqual(rendering, "")
    }
    
    func testNSOrderedSetIsIterated() {
        let rendering = try! Template(string: "{{#collection}}{{key}}{{/collection}}").render(with: boxedNSOrderedSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSOrderedSetIsNotIteratedWithValueForKey() {
        let rendering = try! Template(string: "{{#collection.key}}{{.}}{{/collection.key}}").render(with: boxedNSOrderedSet)
        XCTAssertEqual(rendering, "")
    }
    
    func testNSOrderedSetCountKey() {
        let rendering = try! Template(string: "{{collection.count}}").render(with: boxedNSOrderedSet)
        XCTAssertEqual(rendering, "1")
    }
    
    func testNSOrderedSetKeyFirst() {
        let rendering = try! Template(string: "{{collection.first.key}}").render(with: boxedNSOrderedSet)
        XCTAssertEqual(rendering, "value")
    }
    
    func testNSOrderedSetLastKey() {
        let rendering = try! Template(string: "{{collection.last.key}}").render(with: boxedNSOrderedSet)
        XCTAssertEqual(rendering, "value")
    }
    
}
