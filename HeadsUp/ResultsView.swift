import SwiftUI

struct ResultsView: View {
    let attempts: [WordAttempt]

    var body: some View {
        VStack(spacing: 16) {
            Text("Results")
                .font(.largeTitle)
                .bold()

            Text("Correct: \(attempts.filter { $0.result == .correct }.count)")
            Text("Passed: \(attempts.filter { $0.result == .pass }.count)")

            List(attempts) { attempt in
                Text(attempt.word)
                    .opacity(attempt.result == .correct ? 1.0 : 0.4)
            }
        }
        .padding()
    }
}
