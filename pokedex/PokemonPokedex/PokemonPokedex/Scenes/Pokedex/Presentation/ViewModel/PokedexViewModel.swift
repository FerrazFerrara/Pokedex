import Foundation

protocol PokedexViewModeling {
    func getPokemons(finishLoading: @escaping (Bool) -> Void)
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
            guard let url = URL(string: $0.sprite) else { return PokemonCellModel(name: "Missigno",
                                                                                  number: "#777",
                                                                                  image: Data()) }
            guard let imageData = try? Data(contentsOf: url) else { return PokemonCellModel(name: "Missigno",
                                                                                            number: "#777",
                                                                                            image: Data()) }
            return PokemonCellModel(name: $0.name,
                                    number: "#\($0.id)",
                                    image: imageData)
        }
    }
}

extension PokedexViewModel: PokedexViewModeling {
    func getPokemons(finishLoading: @escaping (Bool) -> Void) {
        getPokemonUseCase.getPokemonList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pokemonList):
                self.pokemons.append(contentsOf: self.parsePokemonEntityToCellModel(pokemonsEntity: pokemonList))
                finishLoading(true)
            case .failure(let error):
                print(error)
                finishLoading(true)
            }
        }
    }

    func numberOfItemsInSection() -> Int {
        pokemons.count
    }

    func cellForItemAt(_ row: Int) -> PokemonCellModel {
        guard pokemons.count > row else {
            return PokemonCellModel(name: "Pikachu", number: "#25", image: Data())
        }
        return pokemons[row]
    }

    func didSelectCellAt(_ row: Int) {

    }
}
