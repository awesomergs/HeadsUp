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
        ZStack {
            if viewModel.isPreGameCountdownActive {
                preGameCountdownView
            } else {
                gameView
            }
        }
        .onAppear {
            viewModel.startPreGameCountdown()
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

    // MARK: - Pre-game Countdown UI

    private var preGameCountdownView: some View {
        Text(preGameText)
            .font(.system(size: 120, weight: .bold))
            .foregroundStyle(.primary)
            .scaleEffect(1.2)
            .animation(.easeOut(duration: 0.3), value: viewModel.preGameCountdown)
    }

    private var preGameText: String {
        if let value = viewModel.preGameCountdown {
            return "\(value)"
        } else {
            return "GO"
        }
    }

    // MARK: - Game UI

    private var gameView: some View {
        VStack(spacing: 32) {
            Text("\(viewModel.session.remainingTime)")
                .font(.title)
                .bold()
                .foregroundStyle(timerColor)

            Text(viewModel.session.currentWord)
                .font(.largeTitle)
                .bold()
                .padding()
                .gesture(swipeGesture)

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
    }

    // MARK: - Timer Color (end-of-round warning)

    private var timerColor: Color {
        switch viewModel.session.remainingTime {
        case 3: return .yellow
        case 2: return .orange
        case 1: return .red
        default: return .primary
        }
    }

    // MARK: - Swipe Input

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

    // MARK: - Tilt Input

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
