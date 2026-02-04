import SwiftUI

struct ResultsView: View {
    let attempts: [WordAttempt]
    let onPlayAgain: () -> Void
    let onGoHome: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Results")
                .font(.largeTitle)
                .bold()

            Text("Correct: \(attempts.filter { $0.result == .correct }.count)")
            Text("Passed: \(attempts.filter { $0.result == .pass }.count)")

            List(attempts) { attempt in
                Text(attempt.word)
                    .opacity(attempt.result == .correct ? 1.0 : 0.4)
            }

            // MARK: - Action Buttons
            HStack(spacing: 16) {
                
                Button("Home") {
                    onGoHome()
                }
                .buttonStyle(.bordered)
                
                
                Button("Play Again") {
                    onPlayAgain()
                }
                .buttonStyle(.borderedProminent)

            }
            .padding(.top)
        }
        .padding()
    }
}
