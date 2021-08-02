import UI
import UIKit

final class PokedexViewController: UIViewController {
    private let viewModel: PokedexViewModeling

    init(viewModel: PokedexViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = PokedexScreen(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
