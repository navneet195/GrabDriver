//
//  MenuController.swift
//  GrabShuttle
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import UIKit
import Firebase

private let cellIdentifier = "MenuCell"

enum MenuOptions: Int, CaseIterable {
    case home
    case incentives
    case mydestination
    case history
    case grabpaywallet
    case grabbenefits
    case notifications
    case blog
    case support
    case logout
    
    var description: String {
        switch self {
        case .home: return "Home"
        case .incentives: return "Incentives"
        case .mydestination: return "My Destination"
        case .history: return "History"
        case .grabpaywallet: return "GrabPay Wallet"
        case .grabbenefits: return "GrabBenefits"
        case .notifications: return "Notifications"
        case .blog: return "Blog"
        case .support: return "Support"
        case .logout: return "Log Out"
        }
    }
}

protocol MenuControllerDelegate {
    func didSelect(option: MenuOptions, user: User?)
}

class MenuController: UITableViewController {
    
    // MARK: - Properties
    
    var delegate: MenuControllerDelegate?
    var user: User? {
        didSet {
            menuHeader.user = user
        }
    }
    
    private lazy var menuHeader: MenuHeader = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140)
        let view = MenuHeader(frame: frame)
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureTableView()
    }
        
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 46
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = menuHeader
    }
}

// MARK: - TableViewDelegate/DataSource

extension MenuController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = MenuOptions(rawValue: indexPath.row)?.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = MenuOptions(rawValue: indexPath.row) else {return}
        delegate?.didSelect(option: option, user: user)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
