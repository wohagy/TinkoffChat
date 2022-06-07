//
//  SettingsViewController.swift
//  iOS Chat
//
//  Created by Macbook on 15.03.2022.
//

import UIKit

protocol IThemesView: AnyObject {
    var colors: IThemeColors? { get set }
    
    func activateCurrentTheme(currentTheme: ThemeType)
}

final class ThemesViewController: UIViewController, IThemesView {
    
    private let classicThemeButton = ThemeButtonView(frame: .zero,
                                                     themeName: "Classic",
                                                     themeType: .classic,
                                                     incomeColor: ThemeType.classic.colors.inComingMessage,
                                                     outcomeColor: ThemeType.classic.colors.outComingMessage,
                                                     screenColor: ThemeType.classic.colors.channelScreenBackground)
    private let dayThemeButton = ThemeButtonView(frame: .zero,
                                                 themeName: "Day",
                                                 themeType: .day,
                                                 incomeColor: ThemeType.day.colors.inComingMessage,
                                                 outcomeColor: ThemeType.day.colors.outComingMessage,
                                                 screenColor: ThemeType.day.colors.channelScreenBackground)
    private let nightThemeButton = ThemeButtonView(frame: .zero,
                                                   themeName: "Night",
                                                   themeType: .night,
                                                   incomeColor: ThemeType.night.colors.inComingMessage,
                                                   outcomeColor: ThemeType.night.colors.outComingMessage,
                                                   screenColor: ThemeType.night.colors.channelScreenBackground)
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [classicThemeButton, dayThemeButton, nightThemeButton])
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var radioButton = [classicThemeButton, dayThemeButton, nightThemeButton]
    
    var colors: IThemeColors?
    
    var presenter: IThemesPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        view.backgroundColor = colors?.outComingMessage
        setupConstraint()
        setupButton()
    }
}

extension ThemesViewController {
    
    func activateCurrentTheme(currentTheme: ThemeType) {
        switch currentTheme {
        case .classic:
            classicThemeButton.isSelected(true)
        case .day:
            dayThemeButton.isSelected(true)
        case .night:
            nightThemeButton.isSelected(true)
        }
    }
    
    private func setupButton() {
        
        nightThemeButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(changeTheme(_:))))
        classicThemeButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                       action: #selector(changeTheme(_:))))
        dayThemeButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                   action: #selector(changeTheme(_:))))
    }
    
    @objc private func changeTheme(_ tapGesture: UITapGestureRecognizer) {
        
        guard let buttonView = tapGesture.view as? ThemeButtonView else { return }
        uncheckButton()
        buttonView.isSelected(true)
        
        presenter?.changeTheme(theme: buttonView.themeType)
        
        view.backgroundColor = buttonView.themeType.colors.outComingMessage
    }
    
    private func uncheckButton() {
        for button in radioButton {
            button.isSelected(false)
        }
    }
}

// MARK: - Constraints

extension ThemesViewController {
    
    private func setupConstraint() {
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
