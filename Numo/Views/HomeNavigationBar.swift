import SwiftUI

struct HomeNavigationBar: View {
    @Binding var selectedMode: LedgerMode
    @Binding var isAddMenuPresented: Bool
    let bottomInset: CGFloat
    @Namespace private var selectionGlass

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            HStack(spacing: 12) {
                HStack(spacing: 0) {
                    ForEach(LedgerMode.allCases) { mode in
                        Button {
                            withAnimation(.snappy(duration: 0.24)) {
                                selectedMode = mode
                                isAddMenuPresented = false
                            }
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: mode.symbol)
                                    .font(.body.bold())
                                Text(mode.rawValue)
                                    .font(.caption.bold())
                            }
                            .foregroundStyle(selectedMode == mode ? Color.white : Color.white.opacity(0.62))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .background {
                                if selectedMode == mode {
                                    Capsule()
                                        .fill(Color.white.opacity(0.035))
                                        .glassEffect(.regular.interactive(), in: Capsule())
                                        .glassEffectID("ledger-selection", in: selectionGlass)
                                        .glassEffectTransition(.matchedGeometry)
                                        .overlay {
                                            Capsule()
                                                .stroke(Color.white.opacity(0.24), lineWidth: 0.7)
                                        }
                                        .padding(3)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(selectedMode == mode ? .isSelected : [])
                    }
                }
                .frame(width: 208, height: 54)
                .glassEffect(.regular.interactive(), in: Capsule())
                .blur(radius: isAddMenuPresented ? 7 : 0)
                .animation(.smooth(duration: 0.35), value: isAddMenuPresented)

                Spacer(minLength: 0)

                Button {
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.76, blendDuration: 0.08)) {
                        isAddMenuPresented.toggle()
                    }
                } label: {
                    Image(systemName: isAddMenuPresented ? "xmark" : "plus")
                        .font(.system(size: 25, weight: .semibold))
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 54, height: 54)
                        .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: Circle())
                .accessibilityLabel(isAddMenuPresented ? "Close add menu" : "Add transaction")
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, bottomInset)
        .frame(maxWidth: .infinity)
    }
}

struct AddActionMenu: View {
    let onSelect: (EntryKind) -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 18) {
            action(kind: .income, color: NumoTheme.mint)
            action(kind: .expense, color: NumoTheme.expense)
        }
    }

    private func action(kind: EntryKind, color: Color) -> some View {
        Button {
            onSelect(kind)
        } label: {
            HStack(spacing: 16) {
                Text(kind.rawValue)
                    .font(.title3.bold())
                    .foregroundStyle(.white)

                Image(systemName: kind.symbol)
                    .font(.title2.bold())
                    .foregroundStyle(color)
                    .frame(width: 58, height: 58)
                    .glassEffect(.regular.tint(color.opacity(0.28)).interactive(), in: Circle())
                    .overlay {
                        Circle().stroke(color.opacity(0.25), lineWidth: 0.7)
                    }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add \(kind.rawValue.lowercased())")
    }
}
