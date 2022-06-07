//
//  ChannelsListTableViewCell.swift
//  iOS Chat
//
//  Created by Macbook on 09.03.2022.
//

import UIKit

final class ChannelsListTableViewCell: UITableViewCell {

    static let identifier = "ChannelsListTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.nameLabelFont
        label.textColor = .label
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.dateFont
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with optionalModel: ChannelModel?, colors: IThemeColors?) {
        guard let model = optionalModel else { return }
        nameLabel.text = model.name
        
        if let message = model.message {
            messageLabel.text = message
            messageLabel.font = Constants.standartMessageFont
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = Constants.noMessagesFont
        }
        
        if let date = model.date {
            dateLabel.text = Date.stringFromDate(date: date)
        } else {
            dateLabel.text = ""
        }
        
        contentView.backgroundColor = colors?.backgroundWhite
        dateLabel.textColor = colors?.dateLabelColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
        messageLabel.font = .none
    }
    
    // MARK: - Constants
    
    private struct Constants {
        static let nameLabelFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let standartMessageFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let noMessagesFont = UIFont.italicSystemFont(ofSize: 13)
        static let unreadMessageFont = UIFont.systemFont(ofSize: 13, weight: .medium)
        static let dateFont = UIFont.systemFont(ofSize: 10, weight: .light)
    }
}

    // MARK: - Constraints

extension ChannelsListTableViewCell {
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -17)
        ])
    }
}
