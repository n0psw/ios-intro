import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spinButton: UIButton!

    private var lastIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        showInitialState()
    }

    private func showInitialState() {
        imageView.image = UIImage(named: "shadow_slave")
        titleLabel.text = favorites[0].title
        descriptionLabel.text = favorites[0].description
        lastIndex = 0
    }

    @IBAction func spinTapped(_ sender: UIButton) {
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: 0..<favorites.count)
        } while newIndex == lastIndex

        lastIndex = newIndex
        let favorite = favorites[newIndex]

        imageView.image = UIImage(named: favorite.imageName)
        titleLabel.text = favorite.title
        descriptionLabel.text = favorite.description
    }
}
