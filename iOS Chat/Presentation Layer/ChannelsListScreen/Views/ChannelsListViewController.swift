//
//  ChannelsListViewController.swift
//  iOS Chat
//
//  Created by Macbook on 25.02.2022.
//

import UIKit
import CoreData

protocol IChannelsListView: AnyObject {
    var colors: IThemeColors? { get set }
    var coreDataService: ICoreDataService? { get set }
    
    func setupFetchedResultsController()
}

final class ChannelsListViewController: UIViewController, IChannelsListView {
    
    private let channelsTableView = UITableView(frame: .zero, style: .plain)
    
    var presenter: IChannelListPresenter?
    var colors: IThemeColors?
    var coreDataService: ICoreDataService?
    private var fetchedResultsController: NSFetchedResultsController<DBChannel>?
    private var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        presenter?.onViewDidLoad()
        view.backgroundColor = colors?.backgroundGray
        setupConstraint()
        customizeNavBar()
        setupTableView()
    }
}

// MARK: - setupTableView(), UITableViewDataSource & UITableViewDelegate

extension ChannelsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        channelsTableView.register(ChannelsListTableViewCell.self, forCellReuseIdentifier: ChannelsListTableViewCell.identifier)
        channelsTableView.dataSource = self
        channelsTableView.delegate = self
        channelsTableView.estimatedRowHeight = 100
        channelsTableView.rowHeight = UITableView.automaticDimension
        channelsTableView.backgroundColor = colors?.backgroundWhite
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections,
              let number = sections[safeIndex: section]?.numberOfObjects else {
            return 0
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelsListTableViewCell.identifier,
                                                 for: indexPath)
        guard let channelsListCell = cell as? ChannelsListTableViewCell else { return cell }
        
        guard let dbChannel = fetchedResultsController?.object(at: indexPath) else { return cell }
        guard let identifier = dbChannel.identifier,
              let name = dbChannel.name else { return cell }
        let channel = ChannelModel(identifier: identifier, name: name, message: dbChannel.lastMessage, date: dbChannel.lastActivity)
        channelsListCell.configure(with: channel, colors: colors)
        
        return channelsListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
      
        let dbChannel = fetchedResultsController?.object(at: indexPath)
        guard let channelID = dbChannel?.identifier,
              let channelName = dbChannel?.name else { return }
        
        presenter?.presentChannel(channelName: channelName, channelID: channelID)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let dbChannel = fetchedResultsController?.object(at: indexPath)
        guard let identifier = dbChannel?.identifier else { return }
        
        presenter?.deleteChannel(with: identifier)
    }
}

// MARK: - setupFetchedResultsController

extension ChannelsListViewController {
    
    func setupFetchedResultsController() {
        
        guard let context = coreDataService?.viewContext,
              let fetchRequest = coreDataService?.getChannelsRequest() else { return }
        
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
        fetchedResultsControllerDelegate = BaseFetchedResultsControllerDelegate(tableView: channelsTableView)
        fetchedResultsController?.delegate = fetchedResultsControllerDelegate
    }
}

// MARK: - ThemesPickerDelegate

extension ChannelsListViewController: ThemesPickerDelegate {
    func changeTheme(to theme: ThemeType) {
        colors = theme.colors
        view.backgroundColor = colors?.backgroundGray
        channelsTableView.backgroundColor = colors?.backgroundWhite
        self.navigationController?.navigationBar.barTintColor = colors?.backgroundGray
        channelsTableView.reloadData()
    }
}

// MARK: - NavBar Customizing, + NavBar buttons actions

extension ChannelsListViewController {
    
    private func customizeNavBar() {
        
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(presentSettingView))
        
        let profileButton = UIBarButtonItem(image: UIImage(systemName: "person.circle"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(presentProfileView))
        let addChannelButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(addNewChannel))
        profileButton.tintColor = .label
        profileButton.accessibilityIdentifier = "profileSettingButton"
        settingButton.tintColor = .label
        addChannelButton.tintColor = .label
        
        self.navigationItem.title = "Channels"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItems = [profileButton, addChannelButton]
        self.navigationItem.leftBarButtonItem = settingButton
        self.navigationController?.navigationBar.barTintColor = colors?.backgroundGray
    }
    
    @objc private func presentProfileView() {
        presenter?.presentProfile()
    }
    
    @objc private func presentSettingView() {
        presenter?.presentThemes(delegate: self)
    }
    
    @objc private func addNewChannel() {
        let alert = UIAlertController(title: "New channel adding", message: "Please, enter channel name", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addButton = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            
            guard let channelName = alert.textFields?.first?.text else { return }
            self?.presenter?.addNewChannel(with: channelName.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        addButton.isEnabled = false
        
        alert.addAction(cancelButton)
        alert.addAction(addButton)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Channel name"
            textfield.addTarget(alert, action: #selector(alert.textDidChange), for: .editingChanged)
        }
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Constraints

extension ChannelsListViewController {
    
    private func setupConstraint() {
        view.addSubview(channelsTableView)
        channelsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            channelsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            channelsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            channelsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            channelsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
