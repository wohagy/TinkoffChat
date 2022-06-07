//
//  ThemeButtonView.swift
//  iOS Chat
//
//  Created by Macbook on 15.03.2022.
//

import UIKit

final class ThemeButtonView: UIView {
    
    private let themeName: String
    private let incomeMessageColor: UIColor
    private let outcomeMessageColor: UIColor
    private let messageScreenColor: UIColor
    
    let themeType: ThemeType
    
    init(frame: CGRect, themeName: String, themeType: ThemeType, incomeColor: UIColor, outcomeColor: UIColor, screenColor: UIColor) {
        self.themeType = themeType
        self.themeName = themeName
        self.incomeMessageColor = incomeColor
        self.outcomeMessageColor = outcomeColor
        self.messageScreenColor = screenColor
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    func isSelected(_ isSelected: Bool) {
        if isSelected {
            messageScreen.layer.borderWidth = 3
        } else {
            messageScreen.layer.borderWidth = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let incomeMessage = UIView()
    private let outcomeMessage = UIView()
    private let messageScreen: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let themeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private func setupViews() {
        incomeMessage.layer.cornerRadius = 5
        incomeMessage.clipsToBounds = true
        outcomeMessage.layer.cornerRadius = 5
        outcomeMessage.clipsToBounds = true
        
        incomeMessage.backgroundColor = incomeMessageColor
        outcomeMessage.backgroundColor = outcomeMessageColor
        messageScreen.backgroundColor = messageScreenColor
        messageScreen.layer.borderColor = #colorLiteral(red: 0.1610154212, green: 0.4136642218, blue: 0.9643692374, alpha: 1)
        themeNameLabel.text = themeName
    }
    
    private func setupConstraints() {
        incomeMessage.translatesAutoresizingMaskIntoConstraints = false
        outcomeMessage.translatesAutoresizingMaskIntoConstraints = false
        messageScreen.addSubview(incomeMessage)
        messageScreen.addSubview(outcomeMessage)
        addSubview(messageScreen)
        addSubview(themeNameLabel)
        
        NSLayoutConstraint.activate([
            incomeMessage.leadingAnchor.constraint(equalTo: messageScreen.leadingAnchor, constant: 25),
            incomeMessage.topAnchor.constraint(equalTo: messageScreen.topAnchor, constant: 15),

            outcomeMessage.trailingAnchor.constraint(equalTo: messageScreen.trailingAnchor, constant: -25),
            outcomeMessage.bottomAnchor.constraint(equalTo: messageScreen.bottomAnchor, constant: -15),
            
            incomeMessage.heightAnchor.constraint(equalTo: outcomeMessage.heightAnchor),
            incomeMessage.widthAnchor.constraint(equalTo: outcomeMessage.widthAnchor),

            incomeMessage.trailingAnchor.constraint(equalTo: outcomeMessage.leadingAnchor, constant: -7),
            incomeMessage.bottomAnchor.constraint(equalTo: outcomeMessage.topAnchor, constant: 20),
            
            messageScreen.topAnchor.constraint(equalTo: self.topAnchor),
            messageScreen.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            messageScreen.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            themeNameLabel.topAnchor.constraint(equalTo: messageScreen.bottomAnchor, constant: 20),
            themeNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            themeNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
