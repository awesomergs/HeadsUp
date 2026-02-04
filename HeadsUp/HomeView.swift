import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var startGame = false
    @State private var showDecks = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Spacer()

                Text("Heads Up")
                    .font(.largeTitle)
                    .bold()

                Text("Round Length")
                    .font(.headline)

                RoundLengthPicker(roundLength: $viewModel.roundLength)

                Button {
                    startGame = true
                } label: {
                    Text("Start")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.enabledDecks.isEmpty)
                
                Spacer()
                // MARK: - Decks
                Button {
                    showDecks = true
                } label: {
                    Text("Manage Decks")
                }
                .buttonStyle(.bordered)
                
                Text("\(viewModel.enabledDecks.count) decks in play")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $startGame) {
                GameView(settings: viewModel.settings)
            }
            .navigationDestination(isPresented: $showDecks) {
                DecksView(viewModel: viewModel)
            }
        }
    }
}
