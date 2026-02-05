import SwiftUI

struct DecksView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                HStack {
                    TextField("Search decks...", text: $viewModel.searchText)
                        .textFieldStyle(.roundedBorder)

                    Text("\(viewModel.totalWordsInPlay) words in play")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                // MARK: - Decks
                DeckSelectionView(
                    categories: viewModel.filteredDecksByCategory,
                    areAllEnabled: viewModel.areAllDecksEnabled,
                    toggleAll: viewModel.setAllDecks,
                    onToggleDeck: viewModel.toggleDeck,
                    isFavorite: viewModel.isFavorite,
                    toggleFavorite: viewModel.toggleFavorite
                )
            }
            .padding()
        }
        .navigationTitle("Decks")
        .navigationBarTitleDisplayMode(.inline)
    }
}
