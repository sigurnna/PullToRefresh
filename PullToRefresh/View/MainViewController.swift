//
//  ViewController.swift
//  PullToRefresh
//
//  Created by 이승준 on 2018. 4. 17..
//  Copyright © 2018년 seungjun. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UIPullToRefreshTableView!
    var strings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strings.append("텍스트1")
        strings.append("텍스트2")
        strings.append("텍스트3")
        strings.append("텍스트4")
        strings.append("텍스트5")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        tableView.loadingHandler = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.tableView.loadingComplete()
            })
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DefaultCell")
        cell.textLabel?.text = strings[indexPath.row]
        
        return cell
    }
}
