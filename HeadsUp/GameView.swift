import SwiftUI

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var motionManager = MotionManager()

    init(settings: GameSettings) {
        _viewModel = StateObject(
            wrappedValue: GameViewModel(settings: settings)
        )
    }

    var body: some View {
        VStack(spacing: 32) {
            Text("\(viewModel.session.remainingTime)")
                .font(.title)
                .bold()

            Text(viewModel.session.currentWord)
                .font(.largeTitle)
                .bold()
                .padding()
                .gesture(swipeGesture)

            // Temporary button (safe to remove later)
            HStack {
                Button("Pass") {
                    viewModel.markPass()
                }

                Button("Correct") {
                    viewModel.markCorrect()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .onAppear {
            viewModel.start()
            startTiltIfNeeded()
        }
        .onDisappear {
            viewModel.stop()
            motionManager.stop()
        }
        .navigationDestination(isPresented: $viewModel.isGameOver) {
            ResultsView(attempts: viewModel.session.attempts)
        }
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 50)
            .onEnded { value in
                guard viewModel.allowsSwipeInput else { return }

                if value.translation.height < -30 {
                    viewModel.markCorrect()
                } else if value.translation.height > 30 {
                    viewModel.markPass()
                }
            }
    }

    private func startTiltIfNeeded() {
        guard viewModel.allowsTiltInput else { return }

        motionManager.onTiltUp = {
            DispatchQueue.main.async {
                viewModel.markCorrect()
            }
        }

        motionManager.onTiltDown = {
            DispatchQueue.main.async {
                viewModel.markPass()
            }
        }

        motionManager.start()
    }
}
