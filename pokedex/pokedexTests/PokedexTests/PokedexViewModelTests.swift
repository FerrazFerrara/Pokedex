import XCTest
@testable import pokedex

final class GetPokemonListStub: GetPokemonListUseCase {
    private(set) var pokemons: [PokemonEntity] = []
    private(set) var error: GetPokemonListError?

    private(set) var callGetPokemons = 0

    func setPokemonList(pokemons: [PokemonEntity]) {
        self.pokemons = pokemons
    }

    func setError(error: GetPokemonListError) {
        self.error = error
    }

    func getPokemonList(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void) {
        callGetPokemons += 1

        if let error = self.error {
            completion(.failure(error))
        } else {
            completion(.success(pokemons))
        }
    }
}

//func getPokemons(finishLoading: @escaping (Bool) -> Void)
//func calculateItemSize(viewSize: Float, itensSpacing: Float) -> Float
//func numberOfItemsInSection() -> Int
//func cellForItemAt(_ row: Int) -> PokemonCellModel
//func didSelectCellAt(_ row: Int)

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
                XCTAssertEqual(self?.useCase.error, GetPokemonListError.generic)
                XCTAssertEqual(self?.useCase.pokemons, [])
            } else {
                XCTFail()
            }
        }
    }

    func testCalculateItemSize_WhenReceiveViewSize_ShouldReturnItemSize() {
        let viewSize: Float = 99
        let itensSpacing: Float = 10
        let itemSize = (viewSize / 3) - (itensSpacing * 2)

        let result = sut.calculateItemSize(viewSize: viewSize, itensSpacing: itensSpacing)

        XCTAssertEqual(itemSize, result)
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
