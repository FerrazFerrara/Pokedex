import UI
import UIKit

final class PokemonInfoViewController: UIViewController {

    let defaultImage = "pokemonDefault"
    let defaultName = "Pikachu"
    let defaultNumber = "#25"
    let defaultTypeImage = ""

    let fontName = "Arial"

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

    private lazy var pokemonType1: UIImageView = {
        let imageDefault = UIImage(named: defaultTypeImage)
        let imageView = UIImageView(image: imageDefault)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        return imageView
    }()

    private lazy var pokemonType2: UIImageView = {
        let imageDefault = UIImage(named: defaultTypeImage)
        let imageView = UIImageView(image: imageDefault)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScene()
    }

}

extension PokemonInfoViewController: ViewConfiguration {
    func buildHierarchy() {

    }

    func addConstraints() {
        
    }
}
