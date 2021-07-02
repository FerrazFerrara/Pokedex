import Foundation

final class APIPokedex {
    var nextURL: String?
}

private extension APIPokedex {
    func fetch<T:Decodable>(url: String, completion: @escaping (Result<T, GetPokemonListError>) -> Void) {
        guard let urlRequest = createURLRequest(url: url) else {
            completion(.failure(.generic))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, _)  in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.generic))
                return
            }

            completion(.success(value))
        }
        task.resume()
    }

    func createURLRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        return  URLRequest(url: url)
    }

    func getPokemonEntity(response: PokemonListResponse, completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        let group = DispatchGroup()
        var getPokemonListError: GetPokemonListError?
        var pokemons: [PokemonEntity] = []

        response.results.forEach { [weak self] pokemonResponse in
            group.enter()
            self?.fetch(url: pokemonResponse.url) { (pokemonInfoResponse: Result<PokemonInfoResponse, GetPokemonListError>) in
                switch pokemonInfoResponse {
                case .success(let pokemonInfo):
                    guard let pokemonEntity = self?.parsePokemonResponseToEntity(pokemonInfo: pokemonInfo) else {
                        getPokemonListError = .noData
                        return
                    }
                    pokemons.append(pokemonEntity)
                    group.leave()
                case .failure(let error):
                    getPokemonListError = error
                    group.leave()
                }
            }
        }

        group.notify(queue: DispatchQueue.global()) {
            if let error = getPokemonListError {
                completion(.failure(error))
            } else {
                completion(.success(pokemons))
            }
        }
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

extension APIPokedex: Repository {
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        let pokemonEndPoint = nextURL ?? "https://pokeapi.co/api/v2/pokemon?limit=51"
        let group = DispatchGroup()
        var getPokemonListError: GetPokemonListError?
        var pokemonListResponse: PokemonListResponse?

        group.enter()
        fetch(url: pokemonEndPoint) { [weak self] (result: Result<PokemonListResponse, GetPokemonListError>) in
            switch result {
            case .success(let response):
                pokemonListResponse = response
                self?.nextURL = response.next
                group.leave()
            case .failure(let error):
                getPokemonListError = error
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.global()) { [weak self] in
            if let response = pokemonListResponse {
                self?.getPokemonEntity(response: response) { (entities: Result<[PokemonEntity], GetPokemonListError>) in
                    completion(entities)
                }
            } else {
                guard let error = getPokemonListError else { return }
                completion(.failure(error))
            }
        }
    }
}
