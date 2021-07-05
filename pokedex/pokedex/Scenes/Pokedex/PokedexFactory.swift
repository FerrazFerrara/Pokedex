import UIKit
import CoreNetwork

enum PokedexFactory {
    static func make() -> UIViewController {
        let repository: Repository = APIPokedex(api: API())
        let useCase: GetPokemonListUseCase = GetPokemonList(repository: repository)
        let viewModel: PokedexViewModeling = PokedexViewModel(getPokemonUseCase: useCase)
        let viewController = PokedexViewController(viewModel: viewModel)

        return viewController
    }
}
