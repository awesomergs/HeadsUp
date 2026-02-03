import SwiftUI

struct DeckSelectionView: View {
    let categories: [(DeckCategory, [Deck])]
    let areAllEnabled: (DeckCategory) -> Bool
    let toggleAll: (DeckCategory, Bool) -> Void
    let onToggleDeck: (Deck) -> Void
    let isFavorite: (DeckCategory) -> Bool
    let toggleFavorite: (DeckCategory) -> Void

    @State private var collapsedCategories: Set<DeckCategory> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(categories, id: \.0) { category, decks in
                categorySection(
                    category: category,
                    decks: decks
                )
            }
        }
    }

    private func categorySection(
        category: DeckCategory,
        decks: [Deck]
    ) -> some View {
        let isCollapsed = collapsedCategories.contains(category)
        let allEnabled = areAllEnabled(category)

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button {
                    toggleCollapse(category)
                } label: {
                    HStack {
                        Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                            .font(.caption)

                        Text(category.title)
                            .font(.headline)
                    }
                }
                .buttonStyle(.plain)
                .onLongPressGesture {
                    toggleAll(category, !allEnabled)
                }

                Spacer()

                Button {
                    toggleFavorite(category)
                } label: {
                    Image(systemName: isFavorite(category) ? "star.fill" : "star")
                        .foregroundStyle(isFavorite(category) ? .yellow : .secondary)
                }
                .buttonStyle(.plain)
            }

            if !isCollapsed {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(decks) { deck in
                        Toggle(deck.name, isOn: Binding(
                            get: { deck.isEnabled },
                            set: { _ in onToggleDeck(deck) }
                        ))
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isCollapsed)
    }

    private func toggleCollapse(_ category: DeckCategory) {
        if collapsedCategories.contains(category) {
            collapsedCategories.remove(category)
        } else {
            collapsedCategories.insert(category)
        }
    }
}
