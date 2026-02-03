import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var startGame = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Heads Up")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Search decks...", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)

                RoundLengthPicker(roundLength: $viewModel.roundLength)

                DeckSelectionView(
                    categories: viewModel.filteredDecksByCategory,
                    areAllEnabled: viewModel.areAllDecksEnabled,
                    toggleAll: viewModel.setAllDecks,
                    onToggleDeck: viewModel.toggleDeck,
                    isFavorite: viewModel.isFavorite,
                    toggleFavorite: viewModel.toggleFavorite
                )



                Button("Start") {
                    startGame = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.enabledDecks.isEmpty)
            }
            .padding()
            .navigationDestination(isPresented: $startGame) {
                GameView(settings: viewModel.settings)
            }
        }
    }
}
