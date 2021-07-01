import UIKit

protocol PokemonViewCellDisplaying {
    func setupCell(with pokemon: PokemonCellModel)
}

final class PokemonViewCell: UICollectionViewCell {

    static let identifier = "PokemonCell"

    let defaultImage = "pokemonDefault"
    let defaultName = "Pikachu"
    let defaultNumber = "#25"

    let fontName = "Arial"

    private lazy var backgroundSubview: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5

        return view
    }()

    private lazy var pokemonImage: UIImageView = {
        let imageDefault = UIImage(named: defaultImage)
        let imageView = UIImageView(image: imageDefault)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        return imageView
    }()

    private lazy var pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = defaultName
        label.textAlignment = .center
        label.font = UIFont(name: fontName, size: 16)

        return label
    }()

    private lazy var pokemonNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = defaultNumber
        label.textAlignment = .center
        label.font = UIFont(name: fontName, size: 14)

        return label
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        setupScene()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokemonViewCell: ViewConfiguration {
    func buildHierarchy() {
        contentView.addSubview(backgroundSubview)
        backgroundSubview.addSubview(pokemonImage)
        backgroundSubview.addSubview(pokemonNameLabel)
        backgroundSubview.addSubview(pokemonNumberLabel)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundSubview.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundSubview.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundSubview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            backgroundSubview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            pokemonNumberLabel.heightAnchor.constraint(equalToConstant: 20),
            pokemonNumberLabel.leadingAnchor.constraint(equalTo: self.backgroundSubview.leadingAnchor),
            pokemonNumberLabel.bottomAnchor.constraint(equalTo: self.backgroundSubview.bottomAnchor),
            pokemonNumberLabel.trailingAnchor.constraint(equalTo: self.backgroundSubview.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            pokemonNameLabel.heightAnchor.constraint(equalToConstant: 16),
            pokemonNameLabel.leadingAnchor.constraint(equalTo: self.backgroundSubview.leadingAnchor),
            pokemonNameLabel.bottomAnchor.constraint(equalTo: self.pokemonNumberLabel.topAnchor),
            pokemonNameLabel.trailingAnchor.constraint(equalTo: self.backgroundSubview.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            pokemonImage.topAnchor.constraint(equalTo: self.backgroundSubview.topAnchor),
            pokemonImage.leadingAnchor.constraint(equalTo: self.backgroundSubview.leadingAnchor),
            pokemonImage.bottomAnchor.constraint(equalTo: self.pokemonNameLabel.topAnchor),
            pokemonImage.trailingAnchor.constraint(equalTo: self.backgroundSubview.trailingAnchor)
        ])
    }
}

extension PokemonViewCell: PokemonViewCellDisplaying {
    func setupCell(with pokemon: PokemonCellModel) {
        pokemonNameLabel.text = pokemon.name
        pokemonNumberLabel.text = pokemon.number
        pokemonImage.image = UIImage(data: pokemon.image)
    }
}
