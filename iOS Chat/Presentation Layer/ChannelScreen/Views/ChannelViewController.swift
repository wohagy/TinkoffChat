//
//  ChannelViewController.swift
//  iOS Chat
//
//  Created by Macbook on 10.03.2022.
//

import UIKit
import FirebaseFirestore
import CoreData

protocol IChannelView: AnyObject {
    var colors: IThemeColors? { get set }
    var coreDataService: ICoreDataService? { get set }
    var userID: String? { get set }
    
    func showInfoAlert(info: String)
    func setNavigationItemTitle(title: String?)
    func setupFetchedResultsController(with id: String)
}

final class ChannelViewController: UIViewController, IChannelView {
    
    let channelTableView = UITableView(frame: .zero, style: .plain)
    private lazy var senderView: IMessageSenderView = MessageSenderView(colors: colors, frame: .zero)
    
    var presenter: IChannelPresenter?
    var colors: IThemeColors?
    var coreDataService: ICoreDataService?
    private var fetchedResultsController: NSFetchedResultsController<DBMessage>?
    private var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.onViewDidLoad()
        view.backgroundColor = colors?.backgroundGray
        setupConstraint()
        setupTableView()
        setupKeyboardObservers()
        senderView.sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        senderView.photoButton.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
    }
    
    @objc private func endEditing() {
        senderView.endEditing()
    }
    
    @objc private func sendMessage() {
        guard let content = senderView.getTextViewMessage() else { return }
        presenter?.sendMessage(with: content)
    }
    
    @objc private func choosePhoto() {
        presenter?.presentInternetImage(delegate: self, previousVC: self)
    }
    
    func showInfoAlert(info: String) {
        let alert = UIAlertController(title: info, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setNavigationItemTitle(title: String?) {
        guard let navigationTitle = title else { return }
        self.navigationItem.title = navigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    deinit {
        removeKeyboardObservers()
    }
}

// MARK: - setupTableView(), UITableViewDataSource & UITableViewDelegate

extension ChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        channelTableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        channelTableView.dataSource = self
        channelTableView.delegate = self
        channelTableView.backgroundColor = colors?.channelScreenBackground
        channelTableView.separatorStyle = .none
        channelTableView.showsVerticalScrollIndicator = false
        channelTableView.transform = CGAffineTransform(rotationAngle: -.pi)
        
        let tableViewTaped = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        channelTableView.addGestureRecognizer(tableViewTaped)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections,
              let number = sections[safeIndex: section]?.numberOfObjects else {
            return 0
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier,
                                                 for: indexPath)
        guard let channelListCell = cell as? ChannelTableViewCell else { return cell }
        
        let dbMessage = fetchedResultsController?.object(at: indexPath)
        guard let message = MessageModel(dbMessage: dbMessage) else { return cell }
        
        channelListCell.configure(with: message, userID: userID, colors: colors)
        channelListCell.transform = CGAffineTransform(rotationAngle: -.pi)
        
        return channelListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - KeyboardObservers Methods

extension ChannelViewController {
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardSize = keyboardFrame.cgRectValue.size
        self.additionalSafeAreaInsets.bottom = keyboardSize.height
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        self.additionalSafeAreaInsets.bottom = .zero
    }
}

// MARK: - setupFetchedResultsController

extension ChannelViewController {
    
    func setupFetchedResultsController(with id: String) {
        
        guard let context = coreDataService?.viewContext,
              let fetchRequest = coreDataService?.getMessagesRequest(channelID: id) else { return }

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            Logger.shared.message(error.localizedDescription)
        }
        
        fetchedResultsController = controller
        fetchedResultsControllerDelegate = BaseFetchedResultsControllerDelegate(tableView: channelTableView)
        fetchedResultsController?.delegate = fetchedResultsControllerDelegate
    }
}

// MARK: - InternetImageDelegate

extension ChannelViewController: ImageCollectionDelegate {
    func getInternetImage(imageLink: String) {
        presenter?.sendMessage(with: imageLink)
    }
}

// MARK: - Constraints

extension ChannelViewController {
    private func setupConstraint() {
        
        channelTableView.translatesAutoresizingMaskIntoConstraints = false
        senderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(channelTableView)
        view.addSubview(senderView)
        
        NSLayoutConstraint.activate([
            channelTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            channelTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            channelTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            channelTableView.bottomAnchor.constraint(equalTo: senderView.topAnchor),
            
            senderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            senderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            senderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            senderView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
