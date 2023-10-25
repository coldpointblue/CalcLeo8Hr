//
//  OrientationChanges.swift
//  Part of the CalcLeo8Hr™ product.
//
//  Language: Swift 5.0
//  Developed on: Xcode, macOS 14.0
//  Target Platform: iOS 15.6
//
//  Author: Hugo S. Diaz
//  Created:  2023-10-11
//  Repository: https://github.com/coldpointblue/CalcLeo8Hr
//  Unique ID:  17AA7090-0F27-461F-8365-F077F0F1E2C6
//
//  License:
//  CalcLeo8Hr is Copyright © 2023 Hugo S. Diaz. All rights reserved worldwide.

import SwiftUI

/// Easily trigger actions inside a view hierarchy on orientation changes
/// Note: Can change local @State var isLandscape : Bool = UIDevice.current.orientation.isLandscape

// Easily trigger actions when orientation changes via .handleOrientationChange
extension View {
    func handleOrientationChange(response orientationChangeHandler: ((Bool) -> Void)? = nil) -> some View {
        self.modifier(OrientationActionViewModifier(orientationChangeHandler: orientationChangeHandler))
    }
}

// Store and propagate orientation through View hierarchy
private struct OrientationPreferenceKey: PreferenceKey {
    static let defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) { value = nextValue() }
}

// ViewModifier handles orientation-related actions
private struct OrientationActionViewModifier: ViewModifier {
    var orientationChangeHandler: ((Bool) -> Void)?
    
    // Define no-operation closure, for clarity
    let noOp: (Bool) -> Void = { _ in }
    
    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .preference(key: OrientationPreferenceKey.self,
                            value: geo.size.width > geo.size.height)
        }
        // noOp used as a fallback
        .onPreferenceChange(OrientationPreferenceKey.self, perform: orientationChangeHandler ?? noOp)
    }
}
