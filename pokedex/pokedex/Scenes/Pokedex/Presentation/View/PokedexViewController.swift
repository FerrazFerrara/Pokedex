import UI
import UIKit

fileprivate enum Layout {
    static let itemSpacing: CGFloat = 10
    static let collectionSpacing: CGFloat = 15
}

final class PokedexViewController: UIViewController {
    private let viewModel: PokedexViewModeling

    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.itemSpacing
        layout.minimumLineSpacing = Layout.itemSpacing
        let itemSize = calculateItemSize()
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokemonViewCell.self, forCellWithReuseIdentifier: PokemonViewCell.identifier)

        return collectionView
    }()

    init(viewModel: PokedexViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScene()
    }

}

extension PokedexViewController: ViewConfiguration {
    func buildHierarchy() {
        view.addSubview(pokemonCollectionView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            pokemonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            pokemonCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.collectionSpacing),
            pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pokemonCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Layout.collectionSpacing)
        ])
    }

    func additionalConfigurations() {
        view.backgroundColor = .white
        pokemonCollectionView.backgroundColor = .white
        
        viewModel.getPokemons { [weak self] (didFinish) in
            if didFinish {
                DispatchQueue.main.sync {
                    self?.pokemonCollectionView.reloadData()
                }
            }
        }
    }
}

private extension PokedexViewController {
    func calculateItemSize() -> CGFloat {
        CGFloat(viewModel.calculateItemSize(viewSize: Float(view.frame.width),
                                    itensSpacing: Float(Layout.itemSpacing)))
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
