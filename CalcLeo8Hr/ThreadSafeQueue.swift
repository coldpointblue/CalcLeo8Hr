//
//  ThreadSafeQueue.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  F81ED086-C1E5-4A59-8B84-BFCE0F8A3BD4
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

/// Thread-safe queue optimized for performance
public final class ThreadSafeQueue<T> {
    private let dispatchQueue: DispatchQueue
    private let deque = Deque<T>()
    
    init(label: String) {
        self.dispatchQueue = DispatchQueue(label: label, attributes: .concurrent)
    }
    
    /// Enqueue with barrier for thread-safety
    /// - Parameter element: Element to be added to the queue.
    func enqueue(_ element: T) {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.deque.append(element)
        }
    }
    
    /// Dequeue in a thread-safe manner
    /// - Returns: Element removed from the front of the queue or `nil` if queue is empty.
    func dequeue() -> T? {
        return dispatchQueue.sync { [weak self] in
            guard let self = self else {
                Logger.debugInfo("Error: self is nil during dequeue operation")
                return nil
            }
            
            return self.deque.popLeft()
        }
    }
    
    /// Flush the queue
    func flushQueue() {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.deque.flush()
        }
    }
}
