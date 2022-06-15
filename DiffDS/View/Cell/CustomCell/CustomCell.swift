import UIKit
import Nuke

class CustomCell: UITableViewCell {

    static let identifier = "CustomCell"

    lazy var avatar: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        applyConstraints()
    }
    
    private func applyConstraints() {
        contentView.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 80),
            avatar.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        contentView.addSubview(userName)
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            userName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            userName.heightAnchor.constraint(equalToConstant: 30),
            userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(item: Item) {
        self.userName.text = item.fullName
        Nuke.loadImage(with: item.owner.avatarURL, into: avatar)
    }
}
