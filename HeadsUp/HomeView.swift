import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
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
                    path.append(
                        GameConfiguration(
                            roundLength: viewModel.roundLength,
                            decks: viewModel.enabledDecks
                        )
                    )
                } label: {
                    Text("Start")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.enabledDecks.isEmpty)

                Text("\(viewModel.enabledDecks.count) decks in play")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Manage Decks") {
                    path.append("decks")
                }
                .buttonStyle(.bordered)

                Spacer()
                Spacer()
            }
            .padding()

            // MARK: - Navigation destinations

            .navigationDestination(for: GameConfiguration.self) { config in
                GameView(
                    configuration: config,
                    goHome: {
                        path = NavigationPath()   // ✅ THIS IS THE KEY
                    }
                )
            }

            .navigationDestination(for: String.self) { value in
                if value == "decks" {
                    DecksView(viewModel: viewModel)
                }
            }
        }
    }
}
