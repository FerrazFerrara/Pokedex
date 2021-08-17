import UI
import UIKit

fileprivate enum Layout {
    static let itemSpacing: CGFloat = 10
    static let collectionSpacing: CGFloat = 15
    static let itemSize: CGFloat = (UIScreen.main.bounds.width / 3) - (Layout.itemSpacing * 2)
}

final class PokedexScreen: UIView {
    let collectionDelegate: UICollectionViewDelegate
    let collectionDataSource: UICollectionViewDataSource

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = .darkGray

        return activity
    }()

    private lazy var pokemonCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.itemSpacing
        layout.minimumLineSpacing = Layout.itemSpacing
        let itemSize = Layout.itemSize
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = collectionDelegate
        collectionView.dataSource = collectionDataSource
        collectionView.register(PokemonViewCell.self, forCellWithReuseIdentifier: PokemonViewCell.identifier)
        collectionView.backgroundView = activityIndicator
        activityIndicator.startAnimating()

        return collectionView
    }()

    init(collectionDelegate: UICollectionViewDelegate,
         collectionDataSource: UICollectionViewDataSource) {
        self.collectionDelegate = collectionDelegate
        self.collectionDataSource = collectionDataSource
        super.init(frame: .zero)

        setupScene()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokedexScreen: ViewConfiguration {
    func buildHierarchy() {
        addSubview(pokemonCollectionView)
    }

    func addConstraints() {
        pokemonCollectionView
            .make([.top, .bottom], equalTo: self)
            .make(.leading, equalTo: self, constant: Layout.collectionSpacing)
            .make(.trailing, equalTo: self, constant: -Layout.collectionSpacing)
    }

    func additionalConfigurations() {
        backgroundColor = .white
        pokemonCollectionView.backgroundColor = .white
    }
}

extension PokedexScreen {
    func reloadCollection() {
        activityIndicator.stopAnimating()
        pokemonCollectionView.reloadData()
    }
}
