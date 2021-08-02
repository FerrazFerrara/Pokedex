import UI
import UIKit

fileprivate enum Layout {
    static let itemSpacing: CGFloat = 10
    static let collectionSpacing: CGFloat = 15
}

final class PokedexScreen: UIView {
    private let viewModel: PokedexViewModeling

    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.itemSpacing
        layout.minimumLineSpacing = Layout.itemSpacing
        let itemSize = calculateItemSize()
        print("aaaaaa \(itemSize)")
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PokemonViewCell.self, forCellWithReuseIdentifier: PokemonViewCell.identifier)

        return collectionView
    }()

    init(viewModel: PokedexViewModeling) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        setupScene()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PokedexScreen {
    func calculateItemSize() -> CGFloat {
        CGFloat(viewModel.calculateItemSize(viewSize: Float(UIScreen.main.bounds.width),
                                    itensSpacing: Float(Layout.itemSpacing)))
    }
}

extension PokedexScreen: ViewConfiguration {
    func buildHierarchy() {
        addSubview(pokemonCollectionView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            pokemonCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pokemonCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.collectionSpacing),
            pokemonCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pokemonCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.collectionSpacing)
        ])
    }

    func additionalConfigurations() {
        backgroundColor = .white
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

extension PokedexScreen: UICollectionViewDelegate, UICollectionViewDataSource {
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
