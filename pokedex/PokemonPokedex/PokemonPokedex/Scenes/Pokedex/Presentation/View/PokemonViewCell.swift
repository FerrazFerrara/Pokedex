import UI
import UIKit

protocol PokemonViewCellDisplaying {
    func setupCell(with pokemon: PokemonCellModel)
}

final class PokemonViewCell: UICollectionViewCell {

    static let identifier = "PokemonCell"

    lazy var view = PokemonViewCellScreen()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addScreen()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokemonViewCell {
    func addScreen() {
        backgroundView = view
        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            view.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}

extension PokemonViewCell: PokemonViewCellDisplaying {
    func setupCell(with pokemon: PokemonCellModel) {
        view.setupCell(with: pokemon)
    }
}
