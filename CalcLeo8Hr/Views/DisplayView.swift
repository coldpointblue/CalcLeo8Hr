import SwiftUI

/// View for the calculator display screen
struct DisplayView: View {
    @Binding var displayValue: String
    
    let numberFontSize: CGFloat = 70
    let indentRight: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayValue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size: numberFontSize))
                .background(CalcColor.display)
                .padding(.trailing, indentRight)
                .accessibilityIdentifier("displayValue") // For UI tests
        }
        .modifier(DisplayViewStyle())
    }
}

struct DisplayViewStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(CalcColor.display)
            .padding(1)
            .border(CalcColor.display, width: 1)
            .minimumScaleFactor(0.5)
    }
}
