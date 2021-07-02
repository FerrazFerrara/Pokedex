import XCTest
@testable import pokedex

class APIPokedexTests: XCTestCase {
    private lazy var sut = APIPokedex()

    func testFetchPokemonList_When_Should() {
        let expectation = XCTestExpectation(description: "get pokemons")
        var pokemonsResult: [PokemonEntity] = []

        sut.fetchPokemons { result in
            switch result {
            case .success(let pokemons):
                pokemonsResult = pokemons
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }

        wait(for: [expectation], timeout: 10.0)

        XCTAssertEqual(pokemonsResult.count, 51)
        XCTAssertNotNil(sut.nextURL)
    }

}
