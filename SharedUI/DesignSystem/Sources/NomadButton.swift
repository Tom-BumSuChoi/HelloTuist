import SwiftUI

public struct NomadButton: View {
    private let title: String
    private let style: Style
    private let action: () -> Void

    public enum Style {
        case primary
        case secondary
        case outline
    }

    public init(_ title: String, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(NomadFonts.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: style == .outline ? 1.5 : 0)
                )
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return NomadColors.accent
        case .outline: return NomadColors.onSurface
        }
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return NomadColors.accent
        case .secondary: return NomadColors.accent.opacity(0.1)
        case .outline: return .clear
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline: return NomadColors.onSurfaceSecondary.opacity(0.3)
        default: return .clear
        }
    }
}
