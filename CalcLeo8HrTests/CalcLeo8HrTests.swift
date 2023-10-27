//
//  CalcLeo8HrTests.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  0D871B54-6F57-4AB2-BF20-F3AE1926D741
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import XCTest
@testable import CalcLeo8Hr

final class CalcLeo8HrTests: XCTestCase {
    private let queuedCount = 75
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContentViewInitialization() {
        let contentView = ContentView(viewModel: CalculatorViewModel())
        XCTAssertNotNil(contentView)
    }
    
    // func testArithmentic() { }
    
    // func testBitcoin() { }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case
        // Code you want to measure the time of
        // self.measure { }
    }
    
    /// Test thread-safety of the enqueue operation
    func testThreadSafetyForEnqueue() throws {
        try validateQueuedCount()
        
        let queue: ThreadSafeQueue<Int> = createQueueForTest(label: "com.coldpointblue.CalcLeo8Hr-Enqueue")
        let expectation = self.expectation(description: "Enqueue items concurrently")
        
        try performConcurrentOperations(for: queue, operation: { (index: Int, queue: ThreadSafeQueue<Int>) in
            queue.enqueue(index)
        }, expectation: expectation)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Validate that all elements were enqueued correctly
        let results = (1...queuedCount).map { _ in queue.dequeue()! }.sorted()
        XCTAssertEqual((1...queuedCount).sorted(), results)
    }
    
    /// Test thread-safety of the dequeue operation
    func testThreadSafetyForDequeue() throws {
        try validateQueuedCount()
        
        let queue: ThreadSafeQueue<Int> = createQueueForTest(label: "com.coldpointblue.CalcLeo8Hr-Dequeue")
        let expectation = self.expectation(description: "Dequeue items concurrently")
        let resultQueue = DispatchQueue(label: "com.coldpointblue.ResultQueue")
        var results: [Int] = []
        
        // Enqueue initial elements
        for i in 1...queuedCount {
            queue.enqueue(i)
        }
        
        try performConcurrentOperations(for: queue, operation: { _,_  in
            if let item = queue.dequeue() {
                resultQueue.sync { results.append(item) }
            }
        }, expectation: expectation)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // Validate that all elements were dequeued correctly
        let sortedResults = results.sorted()
        XCTAssertEqual((1...queuedCount).sorted(), sortedResults, "Dequeued items mismatch")
    }
    
    func createQueueForTest<T>(label: String, sampleElement: T? = nil) -> ThreadSafeQueue<T> {
        return ThreadSafeQueue<T>(label: label)
    }
    
    /// Performs concurrent operations on a `ThreadSafeQueue`.
    func performConcurrentOperations<T>(for queue: ThreadSafeQueue<T>, operation: @escaping (Int, ThreadSafeQueue<T>) -> Void, expectation: XCTestExpectation) throws {
        try validateQueuedCount()
        
        let group = DispatchGroup()
        
        for i in 1...queuedCount {
            group.enter()
            
            DispatchQueue.global().async {
                operation(i, queue)
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            expectation.fulfill()
        }
    }
    
    // MARK: - Helper Functions
    
    /// Validates that queuedCount is greater than 0, otherwise fails test.
    private func validateQueuedCount() throws {
        guard queuedCount > 0 else {
            throw NSError(domain: "com.coldpointblue.CalcLeo8Hr",
                          code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "queuedCount must be greater than zero for this test"])
        }
    }
}
