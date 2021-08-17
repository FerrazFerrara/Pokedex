import UIKit
import UI

final class PokemonViewCellScreen: UIView {
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

extension PokemonViewCellScreen: ViewConfiguration {
    func buildHierarchy() {
        addSubview(backgroundSubview)
        backgroundSubview.addSubview(pokemonImage)
        backgroundSubview.addSubview(pokemonNameLabel)
        backgroundSubview.addSubview(pokemonNumberLabel)
    }

    func addConstraints() {
        backgroundSubview
            .make([.top, .bottom, .leading, .trailing], equalTo: self)

        pokemonNumberLabel
            .make(.height, equalTo: 20)
            .make([.leading, .bottom, .trailing], equalTo: backgroundSubview)

        pokemonNameLabel
            .make([.leading, .trailing], equalTo: backgroundSubview)
            .make(.bottom, equalTo: pokemonNumberLabel, attribute: .top)
            .make(.height, equalTo: 16)

        pokemonImage
            .make([.top, .leading, .trailing], equalTo: backgroundSubview)
            .make(.bottom, equalTo: pokemonNameLabel, attribute: .top)
    }
}

extension PokemonViewCellScreen {
    func setupCell(with pokemon: PokemonCellModel) {
        pokemonNameLabel.text = pokemon.name
        pokemonNumberLabel.text = pokemon.number
        pokemonImage.image = UIImage(data: pokemon.image)
    }
}
