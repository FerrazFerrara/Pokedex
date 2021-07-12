import CoreNetworkProtocols
import UIKit

public enum PokedexFactory {
    public static func make(api: APIRepository) -> UIViewController {
        let repository: Repository = APIPokedex(api: api)
        let useCase: GetPokemonListUseCase = GetPokemonList(repository: repository)
        let viewModel: PokedexViewModeling = PokedexViewModel(getPokemonUseCase: useCase)
        let viewController = PokedexViewController(viewModel: viewModel)

        return viewController
    }
}
