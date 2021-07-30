import CoreNetworkProtocols
import XCTest
@testable import CoreNetwork

struct PokemonDummy: Decodable {
    let id: Int
    let name: String
}

final class NetworkSessionMock: NetworkSession {
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?

    func loadData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, urlResponse, error)
    }
}

final class APITests: XCTestCase {
    lazy var urlValidPokemon = Bundle(for: type(of: self)).url(forResource: "pokemonMock", withExtension: "json")
    lazy var urlInvalidPokemon = Bundle(for: type(of: self)).url(forResource: "invalidPokemonMock", withExtension: "json")
    let networkSession = NetworkSessionMock()
    private lazy var sut = API(networkSession: networkSession)

    func testFetch_WhenUrlIsInvalid_ShouldReturnError() {
        let expectation = XCTestExpectation(description: "Url Error")
        networkSession.error = APIError.urlUnknown

        sut.fetch(endpoint: "") { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, APIError.urlUnknown)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetch_WhenNoDataReturned_ShouldReturnError() {
        let expectation = XCTestExpectation(description: "No Data")

        sut.fetch(endpoint: "https://pokeapi.co/") { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, APIError.noData)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetch_WhenDecoderFailed_ShouldReturnError() throws {
        let expectation = XCTestExpectation(description: "Decoder Error")
        networkSession.error = APIError.decoderError
        let url = try XCTUnwrap(urlInvalidPokemon)
        networkSession.data = try Data(contentsOf: url)

        sut.fetch(endpoint: "https://pokeapi.co/") { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, APIError.decoderError)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetch_WhenSuccess_ShouldReturnValueDecoded() throws {
        let expectation = XCTestExpectation(description: "Success")
        let url = try XCTUnwrap(urlValidPokemon)
        networkSession.data = try Data(contentsOf: url)

        sut.fetch(endpoint: "https://pokeapi.co/") { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(let pokemon):
                XCTAssertEqual(pokemon.id, 132)
                XCTAssertEqual(pokemon.name, "ditto")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
