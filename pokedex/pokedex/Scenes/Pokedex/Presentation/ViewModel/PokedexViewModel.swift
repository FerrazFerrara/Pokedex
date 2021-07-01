protocol PokedexViewModeling {
    func getAllPokemons()
    func numberOfItemsInSection() -> Int
    func cellForItemAt(_ row: Int) -> PokemonCellModel
    func didSelectCellAt(_ row: Int)
}

final class PokedexViewModel {
    var pokemons: [PokemonCellModel] = []
}

extension PokedexViewModel: PokedexViewModeling {
    func getAllPokemons() {
        
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
