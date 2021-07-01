struct PokemonListResponse: Decodable {
    let next: String?
    let previous: String?
    let results: [PokemonResponse]
}

struct PokemonResponse: Decodable {
    let url: String
}
