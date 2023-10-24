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
