import CoreNetworkProtocols

protocol Repository {
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void)
}
