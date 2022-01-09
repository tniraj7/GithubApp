import UIKit
import Kingfisher

class RepositoryCell: UITableViewCell {

    static let cellIdentifier = "repositoryCell"
    
    lazy var thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var repositoryName: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var favoriteButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        button.tintColor = .systemYellow
//        return button
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(repositoryName)
//        contentView.addSubview(favoriteButton)
//        favoriteButton.addTarget(self, action: #selector(onFavoritePressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            thumbnailView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            thumbnailView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            thumbnailView.widthAnchor.constraint(equalToConstant: 70),
            thumbnailView.heightAnchor.constraint(equalToConstant: 70),
            
            repositoryName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            repositoryName.leftAnchor.constraint(equalTo: thumbnailView.rightAnchor, constant: 30),
            repositoryName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            repositoryName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35),
            
//            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
//            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2),
//            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
//            favoriteButton.widthAnchor.constraint(equalToConstant: 40)

        ])
    }
    
    func setupCell(_ repositoryItem: Item) {
        self.thumbnailView.kf.indicatorType = .activity
        self.thumbnailView.kf.setImage(with: URL(string: repositoryItem.owner.avatar_url)!)
        self.repositoryName.text = "\(repositoryItem.full_name)"
    }
    
//    @objc func onFavoritePressed() {
//        UIView.animate(withDuration: 0.8, delay: 0.0,
//          usingSpringWithDamping:  0.3, initialSpringVelocity: 0.0,
//          animations: {
//            self.favoriteButton.frame.size.height = self.favoriteButton.frame.size.height*1.2
//            self.favoriteButton.frame.size.width = self.favoriteButton.frame.size.width*1.2
//            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
//            self.favoriteButton.layoutIfNeeded()
//        },
//          completion: nil
//        )
//    }
}
