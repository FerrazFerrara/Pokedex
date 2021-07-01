import UIKit

final class PokedexViewController: UIViewController {
    private let viewModel: PokedexViewModeling

    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
            pokemonCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pokemonCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            pokemonCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
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
