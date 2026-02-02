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

                RoundLengthPicker(roundLength: $viewModel.roundLength)

                DeckSelectionView(
                    decks: viewModel.settings.decks,
                    onToggle: viewModel.toggleDeck
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
