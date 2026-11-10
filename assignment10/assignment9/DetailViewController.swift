import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    var item: FavoriteItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let item = item else { return }

        title = item.title
        detailImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.details

        for (index, star) in starImageViews.enumerated() {
            if index < item.rating {
                star.image = UIImage(systemName: "star.fill")
            } else {
                star.image = UIImage(systemName: "star")
            }
        }
    }
}
