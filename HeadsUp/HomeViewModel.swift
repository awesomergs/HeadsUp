import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""

    @Published private(set) var favoriteCategories: Set<DeckCategory>

    @Published private(set) var settings: GameSettings

    @Published var roundLength: Int {
        didSet {
            settings.roundLength = roundLength
            preferencesStore.saveRoundLength(roundLength)
        }
    }


    private let preferencesStore = DeckPreferencesStore()


    init() {
        let defaultRoundLength = 60

        let decks = DeckRepository.defaultDecks()

        let savedDeckStates = preferencesStore.loadDeckStates()
        let persistedRoundLength = preferencesStore.loadRoundLength(
            defaultValue: defaultRoundLength
        )

        let mergedDecks = decks.map { deck -> Deck in
            var deck = deck
            if let saved = savedDeckStates[deck.id] {
                deck.isEnabled = saved
            }
            return deck
        }

        self.settings = GameSettings(
            roundLength: persistedRoundLength,
            decks: mergedDecks
        )

        // Then initialize published round length
        self.roundLength = persistedRoundLength
        self.favoriteCategories = preferencesStore.loadFavoriteCategories()

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
        preferencesStore.saveDeckStates(states)
    }

    var enabledDecks: [Deck] {
        settings.enabledDecks
    }

    var filteredDecksByCategory: [(DeckCategory, [Deck])] {
        let filtered = settings.decks.filter { deck in
            searchText.isEmpty ||
            deck.name.localizedCaseInsensitiveContains(searchText)
        }

        let grouped = Dictionary(grouping: filtered, by: { $0.category })

        return grouped
            .map { ($0.key, $0.value) }
            .sorted { lhs, rhs in
                let lhsFav = favoriteCategories.contains(lhs.0)
                let rhsFav = favoriteCategories.contains(rhs.0)

                if lhsFav != rhsFav {
                    return lhsFav && !rhsFav
                }
                return lhs.0.title < rhs.0.title
            }
    }

    
    func areAllDecksEnabled(in category: DeckCategory) -> Bool {
        let decks = settings.decks.filter { $0.category == category }
        return !decks.isEmpty && decks.allSatisfy { $0.isEnabled }
    }

    func setAllDecks(in category: DeckCategory, enabled: Bool) {
        for index in settings.decks.indices {
            if settings.decks[index].category == category {
                settings.decks[index].isEnabled = enabled
            }
        }

        persistDeckStates()
        settings = settings
    }

    func toggleFavorite(_ category: DeckCategory) {
        if favoriteCategories.contains(category) {
            favoriteCategories.remove(category)
        } else {
            favoriteCategories.insert(category)
        }

        preferencesStore.saveFavoriteCategories(favoriteCategories)
    }

    func isFavorite(_ category: DeckCategory) -> Bool {
        favoriteCategories.contains(category)
    }

    
}
