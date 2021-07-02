@testable import pokedex

enum PokemonEntityDumb {
    static let statsDumb = [Stats(baseStat: 5, name: "hp")]
    
    static func pokemon() -> PokemonEntity {
        PokemonEntity(height: 1,
                      id: 25,
                      name: "Pikachu",
                      sprite: "",
                      stats: statsDumb,
                      types: ["Eletric"],
                      weight: 1)
    }

    static func list() -> [PokemonEntity] {
        [pokemon()]
    }
}
