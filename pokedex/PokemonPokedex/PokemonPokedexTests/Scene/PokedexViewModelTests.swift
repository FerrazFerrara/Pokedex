import XCTest
import CoreNetworkProtocols
@testable import PokemonPokedex

final class GetPokemonListStub: GetPokemonListUseCase {
    private(set) var pokemons: [PokemonEntity] = []
    private(set) var error: APIError?

    private(set) var callGetPokemons = 0

    func setPokemonList(pokemons: [PokemonEntity]) {
        self.pokemons = pokemons
    }

    func setError(error: APIError) {
        self.error = error
    }

    func getPokemonList(completion: @escaping (Result<[PokemonEntity], APIError>) -> Void) {
        callGetPokemons += 1

        if let error = self.error {
            completion(.failure(error))
        } else {
            completion(.success(pokemons))
        }
    }
}

final class PokedexViewModelTests: XCTestCase {
    private let useCase = GetPokemonListStub()
    private lazy var sut = PokedexViewModel(getPokemonUseCase: useCase)

    func testGetPokemons_WhenGetPokemons_ShouldCallDidFinish() {
        useCase.setPokemonList(pokemons: PokemonEntityDumb.list())

        sut.getPokemons { [weak self] didFinish in
            if didFinish {
                XCTAssertEqual(self?.useCase.callGetPokemons, 1)
                XCTAssertEqual(self?.useCase.pokemons, PokemonEntityDumb.list())
                XCTAssertNil(self?.useCase.error)
            } else {
                XCTFail()
            }
        }
    }

    func testGetPokemons_WhenGetError_ShouldCallDidFinish() {
        useCase.setError(error: .generic)

        sut.getPokemons { [weak self] didFinish in
            if didFinish {
                XCTAssertEqual(self?.useCase.callGetPokemons, 1)
                XCTAssertEqual(self?.useCase.error, APIError.generic)
                XCTAssertEqual(self?.useCase.pokemons, [])
            } else {
                XCTFail()
            }
        }
    }

    func testNumberOfItemsInSection_WhenHasPokemons_ShouldReturnCountOfPokemons() {
        useCase.setPokemonList(pokemons: PokemonEntityDumb.list())
        sut.getPokemons { [weak self] _ in
            let itensCount = self?.sut.numberOfItemsInSection()
            XCTAssertEqual(itensCount, PokemonEntityDumb.list().count)
        }
    }

    func testNumberOfItemsInSection_WhenHasNoPokemons_ShouldReturnZero() {
        useCase.setError(error: .generic)
        sut.getPokemons { [weak self] _ in
            let itensCount = self?.sut.numberOfItemsInSection()
            XCTAssertEqual(itensCount, 0)
        }
    }

    func testCellForItemAt_WhenHasPokemon_ShouldReturnSpecificPokemonCellModel() {
        useCase.setPokemonList(pokemons: PokemonEntityDumb.list())
        sut.getPokemons { [weak self] _ in
            let result = self?.sut.cellForItemAt(0)
            XCTAssertEqual(result, self?.sut.pokemons[0])
        }
    }

    func testCellForItemAt_WhenHasNoPokemon_ShouldReturnDefaultPokemon() {
        useCase.setError(error: .generic)
        sut.getPokemons { [weak self] _ in
            let result = self?.sut.cellForItemAt(9999)
            XCTAssertEqual(result, PokemonCellModel(name: "Pikachu", number: "#25", image: Data()))
        }
    }
}
