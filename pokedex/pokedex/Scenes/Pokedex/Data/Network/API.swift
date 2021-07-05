import Foundation
import CoreNetwork

final class APIPokedex {
    var nextURL: String?
    var api: APIRepository

    init(api: APIRepository) {
        self.api = api
    }
}

private extension APIPokedex {
    func getPokemonEntity(response: PokemonListResponse, completion: @escaping (Result<[PokemonEntity], APIError>) -> Void) {
        let group = DispatchGroup()
        var getPokemonListError: APIError?
        var pokemons: [PokemonEntity] = []

        response.results.forEach { [weak self] pokemonResponse in
            group.enter()
            self?.api.fetch(url: pokemonResponse.url) { (pokemonInfoResponse: Result<PokemonInfoResponse, APIError>) in
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
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void) {
        let pokemonEndPoint = nextURL ?? "https://pokeapi.co/api/v2/pokemon?limit=51"
        let group = DispatchGroup()
        var getPokemonListError: APIError?
        var pokemonListResponse: PokemonListResponse?

        group.enter()
        api.fetch(url: pokemonEndPoint) { [weak self] (result: Result<PokemonListResponse, APIError>) in
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
                self?.getPokemonEntity(response: response) { (entities: Result<[PokemonEntity], APIError>) in
                    completion(entities)
                }
            } else {
                guard let error = getPokemonListError else { return }
                completion(.failure(error))
            }
        }
    }
}
