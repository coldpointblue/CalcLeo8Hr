//
//  ButtonTapService.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  CA284C3D-4730-4FF9-B162-07459D4D2A85
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import Foundation

/// ButtonTap service to handle business logic.
///
/// Respond to tap with call to enqueue or dequeue with
/// immediate call to custom processButtonTapQueue() to act.
class ButtonTapService {
    let threadSafeQueue: ThreadSafeQueue<String>
    
    init(label: String) {
        self.threadSafeQueue = ThreadSafeQueue<String>(label: label)
    }
    
    func enqueueButtonTap(_ key: String) {
        threadSafeQueue.enqueue(key)
    }
    
    func dequeueButtonTap() -> String? {
        return threadSafeQueue.dequeue()
    }
    
    func flushQueue() {
        threadSafeQueue.flushQueue()
    }
}
