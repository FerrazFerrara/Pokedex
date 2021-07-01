struct PokemonInfoResponse: Decodable {
    let height: Int
    let id: Int
    let name: String
    let sprites: SpritesResponse
    let stats: [StatsResponse]
    let types: [TypesResponse]
    let weight: Int
}

struct SpritesResponse: Decodable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct StatsResponse: Decodable {
    let baseStat: Int
    let stat: StatResponse

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatResponse: Decodable {
    let name: String
}

struct TypesResponse: Decodable {
    let type: TypeResponse
}

struct TypeResponse: Decodable {
    let name: String
}
