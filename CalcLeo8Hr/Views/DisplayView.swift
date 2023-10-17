import SwiftUI

/// View for the calculator display screen
struct DisplayView: View {
    @Binding var displayValue: String
    let numberFontSize: CGFloat = 70
    let indentRight: CGFloat = 24
    
    var body: some View {
        HStack(spacing: 0) {
            Text(displayValue)
                .font(.system(size: numberFontSize))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(CalcColor.display)
                .padding(.trailing, indentRight)
                .accessibilityIdentifier("displayValue") // For UI tests
        }
        .background(CalcColor.display)
        .padding(1)
        .border(CalcColor.display, width: 1)
        .minimumScaleFactor(0.5)
    }
}