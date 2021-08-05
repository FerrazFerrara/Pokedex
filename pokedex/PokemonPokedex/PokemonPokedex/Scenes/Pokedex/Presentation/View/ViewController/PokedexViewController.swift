import UI
import UIKit

final class PokedexViewController: UIViewController {
    private let viewModel: PokedexViewModeling
    private lazy var screen = PokedexScreen(collectionDelegate: self,
                                            collectionDataSource: self)

    init(viewModel: PokedexViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = screen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getPokemons()
    }
}

extension PokedexViewController {
    func getPokemons() {
        viewModel.getPokemons { [weak self] (didFinish) in
            if didFinish {
                DispatchQueue.main.sync {
                    self?.screen.reloadCollection()
                }
            }
        }
    }
}

extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonViewCell.identifier, for: indexPath) as? PokemonViewCell
        cell?.setupCell(with: viewModel.cellForItemAt(indexPath.row))
        return cell ?? PokemonViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCellAt(indexPath.row)
    }
}
