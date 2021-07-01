import Foundation

final class API {
    var nextURL: String?
}

private extension API {
    func fetchPokemonList(completion: @escaping (Result<PokemonListResponse, GetPokemonListError>) -> Void) {
        let pokemonEndPoint = nextURL ?? "https://pokeapi.co/api/v2/pokemon?limit=51"
        guard let urlRequest = createURLRequest(url: pokemonEndPoint) else {
            completion(.failure(.generic))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, _)  in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let pokemonList = try? JSONDecoder().decode(PokemonListResponse.self, from: data) else {
                completion(.failure(.generic))
                return
            }

            completion(.success(pokemonList))
        }
        task.resume()
    }

    func fetchPokemon(url: String, completion: @escaping (Result<PokemonEntity, GetPokemonListError>) -> Void) {
        guard let urlRequest = createURLRequest(url: url) else {
            completion(.failure(.generic))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, _, _)  in
            guard let self = self else {
                completion(.failure(.generic))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let pokemonInfo = try? JSONDecoder().decode(PokemonInfoResponse.self, from: data) else {
                completion(.failure(.generic))
                return
            }

            let pokemonEntity = self.parsePokemonResponseToEntity(pokemonInfo: pokemonInfo)

            completion(.success(pokemonEntity))
        }
        task.resume()
    }

    func createURLRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        return  URLRequest(url: url)
    }

    func parsePokemonResponseToEntity(pokemonInfo: PokemonInfoResponse) -> PokemonEntity {
        let pokemonStats = pokemonInfo.stats.map { Stats(baseStat: $0.baseStat, name: $0.stat.name) }
        let pokemonTypes = pokemonInfo.types.map { $0.type.name }
        return PokemonEntity(height: pokemonInfo.height,
                             id: pokemonInfo.id,
                             name: pokemonInfo.name,
                             sprite: pokemonInfo.sprites.frontDefault,
                             stats: pokemonStats,
                             types: pokemonTypes,
                             weight: pokemonInfo.weight)
    }
}

extension API: Repository {
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        let group = DispatchGroup()
        var pokemons: [PokemonEntity] = []

        fetchPokemonList { [weak self] result in
            switch result {
            case .success(let response):
                for pokemonResult in response.results {
                    group.enter()
                    self?.fetchPokemon(url: pokemonResult.url) { result in
                        switch result {
                        case .success(let pokemonEntity):
                            pokemons.append(pokemonEntity)
                        case .failure(let error):
                            print(error)
                        }
                        group.leave()
                    }
                }
                group.notify(queue: DispatchQueue.global()) {
                    completion(.success(pokemons))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
