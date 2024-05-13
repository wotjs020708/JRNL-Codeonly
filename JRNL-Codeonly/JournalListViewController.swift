//
//  ViewController.swift
//  JRNL-Codeonly
//
//  Created by 어재선 on 5/13/24.
//

import UIKit

class JournalListViewController: UIViewController {
    var tableView: UITableView = {
       let tableView = UITableView()
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let global = view.safeAreaLayoutGuide
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: global.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: global.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: global.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: global.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addJournal))
    }
    
    @objc private func addJournal() {
        let addJournalViewController = AddJournalViewController()
        let navController = UINavigationController(rootViewController: addJournalViewController)
        present(navController, animated: true)
    }


}

