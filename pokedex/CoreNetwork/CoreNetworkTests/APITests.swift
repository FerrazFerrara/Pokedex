import CoreNetworkProtocols
import XCTest
@testable import CoreNetwork

struct PokemonDummy: Decodable {
    let id: Int
    let name: String
}

struct PokemonDecodeErrorFake: Decodable {
    let identifier: Int
    let names: String
}

final class APITests: XCTestCase {
    let urlString = "https://pokeapi.co/api/v2/pokemon/ditto"
    private lazy var sut = API()

    func testFetch_WhenUrlIsInvalid_ShouldReturnError() {
        let expectation = XCTestExpectation(description: "Url Error")

        sut.fetch(url: "") { (result: Result<PokemonDummy, APIError>) in
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
        let urlStringError = "https://pokeapi.co/api/v2/pokemon/999"
        let expectation = XCTestExpectation(description: "No Data")

        sut.fetch(url: urlStringError) { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
//                XCTAssertEqual(error, APIError.noData)
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testFetch_WhenDecoderFailed_ShouldReturnError() {
        let expectation = XCTestExpectation(description: "Decoder Error")

        sut.fetch(url: urlString) { (result: Result<PokemonDecodeErrorFake, APIError>) in
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

    func testFetch_WhenSuccess_ShouldReturnValueDecoded() {
        let expectation = XCTestExpectation(description: "Success")

        sut.fetch(url: urlString) { (result: Result<PokemonDummy, APIError>) in
            switch result {
            case .success(let pokemon):
                XCTAssertEqual(pokemon.id, 132)
                XCTAssertEqual(pokemon.name, "ditto")
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
