import SwiftUI
import UIKit

struct GameView: View {
    @StateObject private var viewModel: GameViewModel
    @State private var motionManager = MotionManager()

    // Replay state
    @State private var replayConfiguration: GameConfiguration?
    @State private var replayWords: [String] = []
    @State private var replayStartIndex: Int = 0
    @State private var isReplaying = false
    
    private let feedbackDelay: TimeInterval = 0.35


    // Navigation control (owned by HomeView)
    let goHome: () -> Void

    // Overlay state
    @State private var overlayColor: Color = .clear
    @State private var overlayOpacity: Double = 0.0
    @State private var overlayScale: CGFloat = 1.0

    // MARK: - Init

    init(
        configuration: GameConfiguration,
        words: [String]? = nil,
        startIndex: Int = 0,
        goHome: @escaping () -> Void
    ) {
        self.goHome = goHome
        _viewModel = StateObject(
            wrappedValue: GameViewModel(
                configuration: configuration,
                words: words,
                startIndex: startIndex
            )
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            if viewModel.isPreGameCountdownActive {
                preGameCountdownView
            } else {
                gameView
            }

            // Full-screen color overlay for correct/pass feedback
            overlayColor
                .ignoresSafeArea()
                .opacity(overlayOpacity)
                .scaleEffect(overlayScale)
                .animation(.easeOut(duration: 0.25), value: overlayOpacity)
                .animation(.spring(response: 0.25, dampingFraction: 0.6), value: overlayScale)
        }
        .onAppear {
            lockToLandscape()
            viewModel.startPreGameCountdown()
            startTiltIfNeeded()
        }
        .onDisappear {
            viewModel.stop()
            motionManager.stop()
            unlockOrientation()
        }

        // Results screen
        .navigationDestination(isPresented: $viewModel.isGameOver) {
            ResultsView(
                attempts: viewModel.session.attempts,
                onPlayAgain: {
                    let replayConfig = viewModel.replayConfiguration()
                    let replayState = viewModel.replayWordState()

                    replayConfiguration = replayConfig
                    replayWords = replayState.words
                    replayStartIndex = replayState.index
                    isReplaying = true
                },
                onGoHome: {
                    goHome()
                }
            )
        }

        // Replay navigation
        .navigationDestination(isPresented: $isReplaying) {
            if let replayConfiguration {
                GameView(
                    configuration: replayConfiguration,
                    words: replayWords,
                    startIndex: replayStartIndex,
                    goHome: goHome
                )
            }
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

            HStack(spacing: 24) {
                Button("Pass") {
                    performPass()
                }

                Button("Correct") {
                    performCorrect()
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }

    // MARK: - Timer Color (last seconds warning)

    private var timerColor: Color {
        switch viewModel.session.remainingTime {
        case 3: return .yellow
        case 2: return .orange
        case 1: return .red
        default: return .primary
        }
    }

    // MARK: - Input Actions (centralized so overlay + haptics are consistent)

    private func performCorrect() {
        showOverlay(color: .green)

        DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDelay) {
            viewModel.markCorrect()
        }
    }

    private func performPass() {
        showOverlay(color: .red)

        DispatchQueue.main.asyncAfter(deadline: .now() + feedbackDelay) {
            viewModel.markPass()
        }
    }


    // MARK: - Overlay animation

    private func showOverlay(color: Color) {
        overlayColor = color
        overlayScale = 1.0
        overlayOpacity = 0.7

        // quick pop
        overlayScale = 1.05

        // fade out after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.2)) {
                overlayOpacity = 0.0
                overlayScale = 1.0
            }
        }
    }

    // MARK: - Swipe Input

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 50)
            .onEnded { value in
                guard viewModel.allowsSwipeInput else { return }

                if value.translation.height < -30 {
                    performCorrect()
                } else if value.translation.height > 30 {
                    performPass()
                }
            }
    }

    // MARK: - Tilt Input

    private func startTiltIfNeeded() {
        guard viewModel.allowsTiltInput else { return }

        motionManager.onCorrect = {
            DispatchQueue.main.async {
                performCorrect()
            }
        }

        motionManager.onPass = {
            DispatchQueue.main.async {
                performPass()
            }
        }

        motionManager.start()
    }

    // MARK: - Orientation Locking

    private func lockToLandscape() {
        // Force device orientation to landscape right (common for Heads Up)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        // Note: You can also set UIWindowScene's interface orientations via Info.plist or AppDelegate for stricter control
    }

    private func unlockOrientation() {
        // Restore to portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
}
