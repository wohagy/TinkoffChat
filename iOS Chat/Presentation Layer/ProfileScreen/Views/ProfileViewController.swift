//
//  ViewController.swift
//  iOS Chat
//
//  Created by Macbook on 18.02.2022.
//

import UIKit

protocol IProfileView: AnyObject {
    var colors: IThemeColors? { get set }
    var profileView: IProfileInfoView { get }

    func showInfoAlert(info: String)
    func showErrorAlert(handler: @escaping ((UIAlertAction) -> Void))
}

final class ProfileViewController: UIViewController, IProfileView {
    
    var presenter: IProfilePresenter?
    var colors: IThemeColors?
    
    private(set) lazy var profileView: IProfileInfoView = ProfileInfoView(colors: colors, frame: .zero)
    
    private let chosePhotoAlert: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Please, choose the source", preferredStyle: .actionSheet)
        return alert
    }()
    
    private lazy var scrollView: AdaptiveScrollView = {
        let scrollView = AdaptiveScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profileView)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        view.backgroundColor = colors?.backgroundWhite
        setupConstraint()
        customizeNavBar()
        addActionsForButtons()
        customizeImagePickerAlert()
    }
    
    private func addActionsForButtons() {
        profileView.editPhotoButton.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(saveWithGCD), for: .touchUpInside)
    }
     
    @objc private func saveWithGCD() {
        presenter?.saveProfileInformation()
    }
    
    func showInfoAlert(info: String) {
        let alert = UIAlertController(title: info, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(handler: @escaping ((UIAlertAction) -> Void)) {
        let alert = UIAlertController(title: "Something was wrong :(", message: "Try save again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Repeat",
                                      style: .default,
                                      handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func pickPhoto() {
        present(chosePhotoAlert, animated: true, completion: nil)
    }
    
    private func customizeImagePickerAlert() {
        let libraryButton = UIAlertAction(title: "From library", style: .default) {[weak self] _ in
            self?.showImagePickerController(source: .photoLibrary)
        }
        let cameraButton = UIAlertAction(title: "From camera", style: .default) {[weak self] _ in
            self?.showImagePickerController(source: .camera)
        }
        let internetButton = UIAlertAction(title: "From internet", style: .default) {[weak self] _ in
            self?.presenter?.presentInternetImage(delegate: self, previousVC: self)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        chosePhotoAlert.addAction(libraryButton)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            chosePhotoAlert.addAction(cameraButton)
        }
        chosePhotoAlert.addAction(internetButton)
        chosePhotoAlert.addAction(cancelButton)
    }
    
    private func customizeNavBar() {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissVC))
        closeButton.tintColor = colors?.buttonBlue

        self.navigationController?.navigationBar.backgroundColor = colors?.backgroundGray
        self.navigationItem.title = "My Profile"
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationController?.navigationBar.barTintColor = colors?.backgroundGray
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: ImageCollectionDelegate {
    func getInternetImage(imageLink: String) {
        presenter?.loadProfilePhoto(imageLink: imageLink)
    }
}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePickerController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileView.setProfileImage(image: editImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileView.setProfileImage(image: originalImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Constraints

extension ProfileViewController {
    
    private func setupConstraint() {
        
        view.addSubview(scrollView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
            frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            frameGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentGuide.leadingAnchor.constraint(equalTo: profileView.leadingAnchor),
            contentGuide.topAnchor.constraint(equalTo: profileView.topAnchor),
            contentGuide.trailingAnchor.constraint(equalTo: profileView.trailingAnchor),
            contentGuide.bottomAnchor.constraint(equalTo: profileView.bottomAnchor),

            frameGuide.widthAnchor.constraint(equalTo: contentGuide.widthAnchor)
        ])
    }
}
