import CoreNetwork

protocol Repository {
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void)
}
