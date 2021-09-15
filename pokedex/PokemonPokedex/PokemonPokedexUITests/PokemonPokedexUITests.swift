//
//  PokemonPokedexUITests.swift
//  PokemonPokedexUITests
//
//  Created by Gabriel Fontes on 18/08/21.
//

import CoreNetwork
import SnapshotTesting
import XCTest
@testable import PokemonPokedex

final class PokemonPokedexUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testPokedexView_WhenSuccess_ShouldPresentCollection() {
        let viewController = PokedexFactory.make(api: API())

        assertSnapshot(matching: viewController, as: .image)
    }

    func testPokemonCell_WhenSuccess_ShouldPresentPokemon() {
        let cell = PokemonViewCell()
        let bundle = Bundle(for: type(of: self))
        guard let data = UIImage(named: "pokemonDefault", in: bundle, with: nil)?.pngData() else { return }
        cell.setupCell(with: PokemonCellModel(name: "Pikachu", number: "#025", image: data))

        assertSnapshot(matching: cell, as: .image)
    }
}
