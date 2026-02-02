import SwiftUI

struct RoundLengthPicker: View {
    @Binding var roundLength: Int
    private let options = [10, 30, 60, 90, 120] //may add custom later ?? but its lowk not needed. 10s for testing - REMOVE REMOVE REMOVE  

    var body: some View {
        Picker("Round Length", selection: $roundLength) {
            ForEach(options, id: \.self) {
                Text("\($0)s").tag($0)
            }
        }
        .pickerStyle(.segmented)
    }
}
