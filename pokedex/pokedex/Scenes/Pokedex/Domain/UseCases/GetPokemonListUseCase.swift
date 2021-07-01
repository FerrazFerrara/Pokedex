import Foundation

enum GetPokemonListError: Error {
    case generic
    case noData
}

protocol GetPokemonListUseCase {

}

struct GetPokemonList: GetPokemonListUseCase {

//    let api = 

    func getPokemonList(completion: @escaping (Result<PokemonEntity, Error>) -> Void) {

    }
}
