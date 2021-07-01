enum GetPokemonListError: Error {
    case generic
    case noData
}

protocol GetPokemonListUseCase {
    func getPokemonList(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void)
}

struct GetPokemonList {
    let repository: Repository
}

extension GetPokemonList: GetPokemonListUseCase {
    func getPokemonList(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        repository.fetchPokemons { result in
            switch result {
            case .success(let pokemons):
                print(pokemons)
                completion(.success(pokemons))
            case .failure(let error):
                print(error)
            }
        }
    }
}
