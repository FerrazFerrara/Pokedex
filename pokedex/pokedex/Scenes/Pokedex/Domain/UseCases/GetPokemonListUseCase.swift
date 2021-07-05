import CoreNetwork

protocol GetPokemonListUseCase {
    func getPokemonList(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void)
}

struct GetPokemonList {
    let repository: Repository
}

extension GetPokemonList: GetPokemonListUseCase {
    func getPokemonList(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void) {
        repository.fetchPokemons { result in
            switch result {
            case .success(let pokemons):
                let pokemonSorted = pokemons.sorted { (pokemon1, pokemon2) -> Bool in
                    pokemon1.id < pokemon2.id
                }
                completion(.success(pokemonSorted))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
