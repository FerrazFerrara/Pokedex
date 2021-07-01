struct PokemonEntity {
    let height: Int
    let id: Int
    let name: String
    let sprite: String
    let stats: [Stats]
    let types: [String]
    let weight: Int
}

struct Stats {
    let baseStat: Int
    let name: String
}
