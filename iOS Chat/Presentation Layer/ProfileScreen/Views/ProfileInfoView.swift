//
//  ProfileView.swift
//  iOS Chat
//
//  Created by Macbook on 27.02.2022.
//

import UIKit

protocol IProfileInfoView: UIView {
    
    var editPhotoButton: UIButton { get }
    var saveButton: UIButton { get }
    
    func savingPresentation(_ isStart: Bool)
    func getEditedData() throws -> ProfileInformation
    func updateProfileInformation(with model: ProfileInformation)
    func setProfileImage(image: UIImage)
}

final class ProfileInfoView: UIView, IProfileInfoView {
    
    private var colors: IThemeColors?
    
    private let profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let editPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = . label
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(colors?.buttonBlue,
                             for: .normal)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    private(set) lazy var saveButton = getProfileScreenButton(title: "Save")
    private lazy var cancelButton = getProfileScreenButton(title: "Cancel")
    
    private let saveIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var nameLabel = getProfileScreenLabel(text: "Name Surname", font: Constants.bigFont)
    private lazy var locationLabel = getProfileScreenLabel(text: "Location", font: Constants.smallFont)
    
    private lazy var locationTextField = getProfileViewTextField(placeHolder: "Location", font: Constants.smallFont)
    private lazy var nameTextField = getProfileViewTextField(placeHolder: "Name Surname", font: Constants.bigFont)
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "type your bio"
        textView.backgroundColor = .none
        textView.font = Constants.smallFont
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = #colorLiteral(red: 0.874432981, green: 0.8745591044, blue: 0.8744053245, alpha: 1)
        return textView
    }()
    
    init(colors: IThemeColors?, frame: CGRect) {
        self.colors = colors
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
        addActionsForButtons()
        setupAccessibilityIdentifiers()
        
        nameLabel.textAlignment = .center
        nameTextField.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAccessibilityIdentifiers() {
        self.accessibilityIdentifier = "profileInfoView"
        profilePhoto.accessibilityIdentifier = "profilePhotoImageView"
        nameLabel.accessibilityIdentifier = "profileNameLabel"
        nameTextField.accessibilityIdentifier = "profileNameTextField"
        locationLabel.accessibilityIdentifier = "profileLocationLabel"
        locationTextField.accessibilityIdentifier = "profileLocationTextField"
        bioTextView.accessibilityIdentifier = "profileBioTextView"
        editButton.accessibilityIdentifier = "editProfileInfoButton"
        editPhotoButton.accessibilityIdentifier = "editProfilePhotoButton"
        saveButton.accessibilityIdentifier = "saveProfileInfoChangesButton"
        cancelButton.accessibilityIdentifier = "cancelProfileInfoChangesButton"
    }
    
    private func shakeView(view: UIView) {
        let animationMove = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        
        let pos = view.layer.position
        
        let forwardPos = CGPoint(x: view.layer.position.x - 5,
                                 y: view.layer.position.y - 5)
        let backPos = CGPoint(x: view.layer.position.x + 5,
                              y: view.layer.position.y + 5)
        animationMove.values = [pos, forwardPos, pos, backPos, pos]
        
        let animationRotate = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let radians: Double = .pi / 10
        animationRotate.values = [0, -radians, 0, radians, 0]
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.autoreverses = false
        group.animations = [animationMove, animationRotate]
        
        view.layer.add(group, forKey: "shakeAnimation")
    }
    
    private func addSubviews() {
        addSubview(profilePhoto)
        addSubview(editPhotoButton)
        addSubview(editButton)
        
        addSubview(cancelButton)
        addSubview(saveButton)
        
        addSubview(nameLabel)
        addSubview(nameTextField)
        
        addSubview(bioTextView)
        
        addSubview(locationLabel)
        addSubview(locationTextField)
        
        addSubview(saveIndicator)
    }
    
    private func addActionsForButtons() {
        editButton.addTarget(self, action: #selector(editProfileInformation), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
    }
    
    private func remakeElements(for isEditMode: Bool) {
        bioTextView.isEditable = isEditMode
        bioTextView.backgroundColor = isEditMode ? colors?.backgroundGray : .none
        bioTextView.layer.borderWidth = isEditMode ? 1 : 0
        
        nameLabel.isHidden = isEditMode
        nameTextField.isHidden = !isEditMode
        
        locationLabel.isHidden = isEditMode
        locationTextField.isHidden = !isEditMode
        
        editButton.isHidden = isEditMode
        editPhotoButton.isHidden = !isEditMode
        
        saveButton.isHidden = !isEditMode
        cancelButton.isHidden = !isEditMode
    }
    
    private var nameOldValue: String?
    private var bioOldValue: String?
    private var locationOldValue: String?
    private var imageInitialValue: UIImage?
    
    @objc private func editProfileInformation() {
        remakeElements(for: true)
        nameOldValue = nameLabel.text
        bioOldValue = bioTextView.text
        locationOldValue = locationLabel.text
        imageInitialValue = profilePhoto.image
        shakeView(view: cancelButton)
    }
    
    @objc private func cancelEditing() {
        remakeElements(for: false)
        nameTextField.text = nameLabel.text
        locationTextField.text = locationLabel.text
        bioTextView.text = bioOldValue
    }
    
    func savingPresentation(_ isStart: Bool) {
        remakeElements(for: false)
        nameLabel.isHidden = isStart
        bioTextView.isHidden = isStart
        locationLabel.isHidden = isStart
        saveIndicator.isHidden = !isStart
        editButton.isHidden = isStart
        if isStart {
            saveIndicator.startAnimating()
        } else {
            saveIndicator.stopAnimating()
        }
    }
    
    func getEditedData() throws -> ProfileInformation {
        
        guard let name = nameTextField.text, nameTextField.text != "" else {
            throw ProfileInformationError.emptyName
        }
        
        guard let location = locationTextField.text, locationTextField.text != "" else {
            throw ProfileInformationError.emptyLocation
        }
        
        guard let bio = bioTextView.text, bioTextView.text != "" else {
            throw ProfileInformationError.emptyBio
        }
        
        let image = getEditedImage()
        
        guard name != nameOldValue || bio != bioOldValue || location != locationOldValue || image != nil else {
            throw ProfileInformationError.nothingChanged
        }
        
        return ProfileInformation(name: name, bio: bio, location: location, image: image)
    }
    
    private func getEditedImage() -> UIImage? {
        guard let oldImage = imageInitialValue,
              let newImage = profilePhoto.image else {
            return nil
        }
        guard oldImage != newImage else { return nil }
        return newImage
    }
    
    func updateProfileInformation(with model: ProfileInformation) {
        nameLabel.text = model.name
        nameTextField.text = model.name
        bioTextView.text = model.bio
        locationLabel.text = model.location
        locationTextField.text = model.location
        if let image = model.image {
            profilePhoto.image = image
        }
    }
    
    func setProfileImage(image: UIImage) {
        profilePhoto.image = image
    }
    
    private func getProfileScreenButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = colors?.backgroundGray
        button.setTitle(title, for: .normal)
        button.clipsToBounds = true
        button.setTitleColor(colors?.buttonBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.isHidden = true
        return button
    }
    
    private func getProfileScreenLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = text
        return label
    }
    
    private func getProfileViewTextField(placeHolder: String, font: UIFont) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = colors?.backgroundGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        textField.text = placeHolder
        textField.placeholder = placeHolder
        textField.borderStyle = .roundedRect
        textField.font = font
        textField.clearButtonMode = .whileEditing
        return textField
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width / 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    private struct Constants {
        static let bigFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        static let smallFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}

// MARK: - Constraints

extension ProfileInfoView {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profilePhoto.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profilePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 7),
            profilePhoto.widthAnchor.constraint(equalToConstant: 240),
            profilePhoto.heightAnchor.constraint(equalToConstant: 240),
            
            editPhotoButton.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: -12),
            editPhotoButton.leadingAnchor.constraint(equalTo: profilePhoto.leadingAnchor),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 40),
            editPhotoButton.widthAnchor.constraint(equalToConstant: 40),
            
            editButton.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: -12),
            editButton.trailingAnchor.constraint(equalTo: profilePhoto.trailingAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65),
            
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65),
            
            bioTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bioTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            bioTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65),
            
            locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 3),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 68),
            
            locationTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationTextField.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 3),
            locationTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 65),
            
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            cancelButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 60),
            
            saveButton.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            
            saveIndicator.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 80),
            saveIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
