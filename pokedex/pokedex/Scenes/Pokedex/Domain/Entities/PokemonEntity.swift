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

extension PokemonEntity: Equatable {
    static func == (lhs: PokemonEntity, rhs: PokemonEntity) -> Bool {
        lhs.id == rhs.id
    }
}
