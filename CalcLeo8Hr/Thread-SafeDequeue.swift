//
//  Thread-SafeDequeue.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  63FBCEC8-CF46-4630-88EE-5E29728AE463
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

/// Doubly-Linked Node
private class Node<T> {
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?
    
    init(_ value: T) {
        self.value = value
    }
}

/// Thread-safe Optimized Deque Data Structure
final class Deque<T> {
    private var head: Node<T>?
    private var tail: Node<T>?
    private lazy var lock = NSLock()
    
    // MARK: - Deque Operations
    
    /// Appends an element to the end of the deque.
    func append(_ element: T) {
        lock.lock(); defer { lock.unlock() }
        let newNode = Node(element)
        guard let tail = self.tail else {
            head = newNode
            self.tail = newNode
            return
        }
        newNode.previous = tail
        tail.next = newNode
        self.tail = newNode
    }
    
    /// Appends an element to the beginning of the deque.
    func appendLeft(_ element: T) {
        lock.lock(); defer { lock.unlock() }
        let newNode = Node(element)
        guard let head = self.head else {
            tail = newNode
            self.head = newNode
            return
        }
        newNode.next = head
        head.previous = newNode
        self.head = newNode
    }
    
    /// Pops an element from the end of the deque.
    /// Returns `nil` if the deque is empty.
    func pop() -> T? {
        lock.lock(); defer { lock.unlock() }
        guard let tail = self.tail else { return nil }
        self.tail = tail.previous
        self.tail?.next = nil
        return tail.value
    }
    
    /// Pops an element from the beginning of the deque.
    /// Returns `nil` if the deque is empty.
    func popLeft() -> T? {
        lock.lock(); defer { lock.unlock() }
        guard let head = self.head else { return nil }
        self.head = head.next
        self.head?.previous = nil
        return head.value
    }
    
    func flush() {
        head = nil
        tail = nil
    }
    
    // MARK: - Peek Operations
    
    /// Peeks at the end of the deque.
    /// Returns `nil` if the deque is empty.
    func peek() -> T? {
        lock.lock(); defer { lock.unlock() }
        return self.tail?.value
    }
    
    /// Peeks at the beginning of the deque.
    /// Returns `nil` if the deque is empty.
    func peekLeft() -> T? {
        lock.lock(); defer { lock.unlock() }
        return self.head?.value
    }
}
