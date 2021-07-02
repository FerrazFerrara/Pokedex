import XCTest
@testable import pokedex

final class RepositoryStub: Repository {
    private(set) var pokemons: [PokemonEntity] = []
    private(set) var error: GetPokemonListError?

    private(set) var callFetchPokemons = 0

    func setPokemonList(pokemons: [PokemonEntity]) {
        self.pokemons = pokemons
    }

    func setError(error: GetPokemonListError) {
        self.error = error
    }

    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        callFetchPokemons += 1

        if let error = self.error {
            completion(.failure(error))
        } else {
            completion(.success(pokemons))
        }
    }
}

final class GetPokemonListUseCaseTests: XCTestCase {
    private let repository = RepositoryStub()
    private lazy var sut: GetPokemonListUseCase = GetPokemonList(repository: repository)

    func testGetPokemonList_WhenSuccessfullyGetPokemonList_ShouldReturnPokemonSorted() {
        repository.setPokemonList(pokemons: PokemonEntityDumb.list())

        sut.getPokemonList { result in
            switch result {
            case .success(let entity):
                XCTAssertEqual(self.repository.callFetchPokemons, 1)
                XCTAssertEqual(PokemonEntityDumb.list(), entity)
            case .failure(_):
                XCTFail()
            }
        }
    }

    func testGetPokemonList_WhenReceiveError_ShouldReturnError() {
        repository.setError(error: .generic)

        sut.getPokemonList { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(self.repository.callFetchPokemons, 1)
                XCTAssertEqual(GetPokemonListError.generic, error)
            }
        }
    }
}
