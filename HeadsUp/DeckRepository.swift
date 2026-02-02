import Foundation

struct DeckRepository {
    static func defaultDecks() -> [Deck] {
        [
            Deck(
                id: "marvel",
                name: "Marvel Characters",
                words: [
                    "The Avengers",
                    "Iron Man",
                    "Captain America",
                    "Thor",
                    "Hulk",
                    "Black Widow",
                    "Hawkeye",
                    "Spider-Man",
                    "Doctor Strange",
                    "Scarlet Witch",
                    "Vision",
                    "Black Panther",
                    "Ant-Man",
                    "Wasp",
                    "Captain Marvel",
                    "Star-Lord",
                    "Gamora",
                    "Rocket Raccoon",
                    "Groot",
                    "Loki",
                    "Thanos",
                    "Nick Fury",
                    "Winter Soldier",
                    "Shang-Chi",
                    "Deadpool",
                    "Wolverine",
                    "X-Men"
                ]
            ),
            Deck(
                id: "dc",
                name: "DC Characters",
                words: [
                    "Batman",
                    "Superman",
                    "Wonder Woman",
                    "The Flash",
                    "Aquaman",
                    "Cyborg",
                    "Green Lantern",
                    "Robin",
                    "Joker",
                    "Harley Quinn",
                    "Lex Luthor",
                    "Darkseid",
                    "Catwoman",
                    "Nightwing",
                    "Batgirl",
                    "The Riddler",
                    "Bane",
                    "Poison Ivy",
                    "Supergirl",
                    "Shazam"
                ]
            ),
            Deck(
                id: "og-mc-youtubers",
                name: "Minecraft YouTubers (OG)",
                words: [
                    "DanTDM",
                    "Dr. Trayaurus",
                    "Grimm",
                    "StampyLongHead",
                    "iBallisticSquid",
                    "iBallisticSquid",
                    "PopularMMOs",
                    "GamingWithJen",
                    "CaptainSparklez",
                    "SkyDoesMinecraft",
                    "Technoblade",
                    "Dream",
                    "GeorgeNotFound",
                    "Sapnap",
                    "BadBoyHalo",
                    "AntVenom",
                    "BajanCanadian",
                    "JeromeASF",
                    "PrestonPlayz",
                    "Ssundee"
                ]
            ),
            Deck(
                id: "hermitcraft",
                name: "Hermitcraft",
                words: [
                    "Grian",
                    "Mumbo Jumbo",
                    "GoodTimesWithScar",
                    "Iskall",
                    "ImpulseSV",
                    "Rendog",
                    "Xisuma",
                    "TangoTek",
                    "Etho",
                    "Bdubs",
                    "FalseSymmetry",
                    "Zedaph",
                    "PearlescentMoon",
                    "GeminiTay",
                    "Keralis",
                    "Docm77",
                    "Cubfan",
                    "JoeHills"
                ]
            ),
            Deck(
                id: "fortnite",
                name: "Fortnite",
                words: [
                    "Battle Bus",
                    "Tilted Towers",
                    "Loot Lake",
                    "Pleasant Park",
                    "Retail Row",
                    "Dusty Depot",
                    "Victory Royale",
                    "Chug Jug",
                    "Shield Potion",
                    "Boogie Bomb",
                    "S.C.A.R.",
                    "Reboot Van",
                    "Storm Circle"
                ]
            ),
            Deck(
                id: "attack_on_titan",
                name: "Attack on Titan",
                words: [
                    "Eren Yeager",
                    "Mikasa Ackerman",
                    "Levi Ackerman",
                    "Armin Arlert",
                    "Erwin Smith",
                    "Hange Zoe",
                    "Jean Kirstein",
                    "Connie Springer",
                    "Sasha Blouse",
                    "Reiner Braun",
                    "Bertholdt Hoover",
                    "Annie Leonhart",
                    "Zeke Yeager",
                    "Historia Reiss",
                    "Ymir",
                    "Attack Titan",
                    "Colossal Titan",
                    "Armored Titan",
                    "Female Titan",
                    "Beast Titan",
                    "Shiganshina",
                    "Wall Maria",
                    "Wall Rose",
                    "Wall Sina",
                    "Paradis Island",
                    "Marley",
                    "ODM Gear",
                    "Survey Corps",
                    "Titan Shifters",
                    "The Rumbling"
                ]
            )

        ]
    }
}
