import Foundation

protocol PokedexViewModeling {
    func getAllPokemons(finishLoading: @escaping (Bool) -> Void)
    func calculateItemSize(viewSize: Float, itensSpacing: Float) -> Float
    func numberOfItemsInSection() -> Int
    func cellForItemAt(_ row: Int) -> PokemonCellModel
    func didSelectCellAt(_ row: Int)
}

//protocol CollectionViewDataSourceDelegate {
//    func calculateItemSize(viewSize: Float, itensSpacing: Float) -> Float
//    func numberOfItemsInSection() -> Int
//    func cellForItemAt(_ row: Int) -> PokemonCellModel
//    func didSelectCellAt(_ row: Int)
//} seria melhor separar assim?

final class PokedexViewModel {
    let getPokemonUseCase: GetPokemonListUseCase
    var pokemons: [PokemonCellModel] = []

    init(getPokemonUseCase: GetPokemonListUseCase) {
        self.getPokemonUseCase = getPokemonUseCase
    }
}

private extension PokedexViewModel {
    func parsePokemonEntityToCellModel(pokemonsEntity: [PokemonEntity]) -> [PokemonCellModel] {
        pokemonsEntity.map {
            guard let imageData = $0.sprite.data(using: .utf16) else { return PokemonCellModel(name: "Missigno",
                                                                                               number: "#777",
                                                                                               image: Data()) }
            return PokemonCellModel(name: $0.name,
                                    number: "#\($0.id)",
                                    image: imageData)
        }
    }
}

extension PokedexViewModel: PokedexViewModeling {
    func getAllPokemons(finishLoading: @escaping (Bool) -> Void) {
        getPokemonUseCase.getPokemonList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pokemonList):
                self.pokemons = self.parsePokemonEntityToCellModel(pokemonsEntity: pokemonList)
                finishLoading(true)
            case .failure(let error):
                print(error)
                finishLoading(true)
            }
        }
    }

    func calculateItemSize(viewSize: Float, itensSpacing: Float) -> Float {
        (viewSize / 3) - (itensSpacing * 2)
    }

    func numberOfItemsInSection() -> Int {
        pokemons.count
    }
    
    func cellForItemAt(_ row: Int) -> PokemonCellModel {
        pokemons[row]
    }

    func didSelectCellAt(_ row: Int) {

    }
}
