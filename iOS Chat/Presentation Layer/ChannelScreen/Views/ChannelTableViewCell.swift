//
//  DialogTableViewCell.swift
//  iOS Chat
//
//  Created by Macbook on 10.03.2022.
//

import UIKit

final class ChannelTableViewCell: UITableViewCell {

    static let identifier = "ChannelTableViewCell"

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.standartMessageFont
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let photoImageView: InternetImageView = {
        let imageView = InternetImageView()
        imageView.image = UIImage(named: "imagePlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.nameLabelFont
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.dateFont
        label.textAlignment = .right
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, messageLabel, dateLabel, photoImageView])
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let messageView = UIView()
    
    private lazy var leadingConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
    private lazy var trailingConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        messageView.addSubview(stack)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with optionalModel: MessageModel?, userID: String?, colors: IThemeColors?) {
        guard let model = optionalModel,
              let userID = userID else { return }
        
        if let url = findURL(in: model.content) {
            photoImageView.setImageFromInternet(imageLink: url)
        } else {
            photoImageView.isHidden = true
        }
        
        nameLabel.text = model.senderName
        messageLabel.text = model.content
        dateLabel.text = Date.stringFromDate(date: model.created)
        contentView.backgroundColor = colors?.channelScreenBackground
        rebuildMessageView(for: model.senderId != userID, colors: colors)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
        photoImageView.image = UIImage(named: "imagePlaceholder")
        photoImageView.isHidden = false
        NSLayoutConstraint.deactivate([leadingConstraint, trailingConstraint])
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let nameLabelFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let standartMessageFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let dateFont = UIFont.systemFont(ofSize: 10, weight: .light)
    }
}

// MARK: - Constraints

extension ChannelTableViewCell {
    
    private func findURL(in message: String) -> String? {
        
        var url: String?
        let input = message
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return url }
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let foundUrl = input[range]
            url = String(foundUrl)
        }
        return url
    }
}

// MARK: - Constraints

extension ChannelTableViewCell {
    
    private func rebuildMessageView(for isIncoming: Bool, colors: IThemeColors?) {
        messageView.layer.cornerRadius = 9
        messageView.clipsToBounds = true
        
        if isIncoming {
            leadingConstraint.isActive = true
            messageView.backgroundColor = colors?.inComingMessage
        } else {
            trailingConstraint.isActive = true
            messageView.backgroundColor = colors?.outComingMessage
        }
    }
    
    private func setupConstraint() {
        
        NSLayoutConstraint.activate([
            messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            stack.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -12),
            
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            photoImageView.heightAnchor.constraint(lessThanOrEqualTo: photoImageView.widthAnchor)
        ])
    }
}
