import SwiftUI

public struct NomadTextField: View {
    private let placeholder: String
    @Binding private var text: String
    private let icon: String?

    public init(_ placeholder: String, text: Binding<String>, icon: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
    }

    public var body: some View {
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundColor(NomadColors.onSurfaceSecondary)
                    .frame(width: 20)
            }
            TextField(placeholder, text: $text)
                .font(NomadFonts.body)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(NomadColors.surface)
        .cornerRadius(12)
    }
}
