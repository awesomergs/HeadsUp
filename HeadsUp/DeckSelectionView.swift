import SwiftUI

struct DeckSelectionView: View {
    let decks: [Deck]
    let onToggle: (Deck) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Decks")
                .font(.headline)

            ForEach(decks) { deck in
                Toggle(deck.name, isOn: Binding(
                    get: { deck.isEnabled },
                    set: { _ in onToggle(deck) }
                ))
            }
        }
    }
}
