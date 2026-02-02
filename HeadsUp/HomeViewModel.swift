import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var settings: GameSettings
    @Published var roundLength: Int {
        didSet { settings.roundLength = roundLength }
    }

    private let preferencesStore = DeckPreferencesStore()

    init() {
        let decks = DeckRepository.defaultDecks()
        let savedStates = preferencesStore.load()

        let mergedDecks = decks.map { deck in
            var deck = deck
            if let saved = savedStates[deck.id] {
                deck.isEnabled = saved
            }
            return deck
        }

        let initialRoundLength = 60
        self.settings = GameSettings(
            roundLength: initialRoundLength,
            decks: mergedDecks
        )
        self.roundLength = initialRoundLength
    }

    func toggleDeck(_ deck: Deck) {
        guard let index = settings.decks.firstIndex(where: { $0.id == deck.id }) else { return }
        settings.decks[index].isEnabled.toggle()
        persistDeckStates()
        settings = settings
    }

    private func persistDeckStates() {
        let states = Dictionary(
            uniqueKeysWithValues: settings.decks.map { ($0.id, $0.isEnabled) }
        )
        preferencesStore.save(states)
    }

    var enabledDecks: [Deck] {
        settings.enabledDecks
    }
}
