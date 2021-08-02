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
        backgroundView = view
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PokemonViewCell: PokemonViewCellDisplaying {
    func setupCell(with pokemon: PokemonCellModel) {
        view.setupCell(with: pokemon)
    }
}
