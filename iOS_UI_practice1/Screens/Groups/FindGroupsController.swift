//
//  AllGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 03.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit
import Kingfisher

class AllGroupsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    var groupsToShow = [VKGroup]()
    var vkAPI = VKApi()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "GroupsCell", bundle: nil), forCellReuseIdentifier: "GroupsTemplate")
        tableView.estimatedRowHeight = 75
    }
}

// MARK: - Search
extension AllGroupsController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.trimmingCharacters(in: CharacterSet(charactersIn: " ")).isEmpty {
            searchInGroups(searchText: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    private func searchInGroups(searchText: String) {
        if searchText != "" {
            vkAPI.searchGroups(apiVersion: Session.shared.actualAPIVersion,
                               token: Session.shared.token,
                               searchText: searchText)
            .done { groups in
                self.groupsToShow = groups
                self.tableView.reloadData()
            }
            .catch { error in
                print("Error requesting groups search: \(error)")
            }
        } else {
            self.groupsToShow = [VKGroup]()
            self.tableView.reloadData()
        }
    }
}

extension AllGroupsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsToShow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTemplate", for: indexPath) as! GroupsCell
        
        cell.caption.text = groupsToShow[indexPath.row].name
        cell.groupType.text = groupsToShow[indexPath.row].theme
        let membersCount = groupsToShow[indexPath.row].membersCount
        
        if let imageURL = URL(string: self.groupsToShow[indexPath.row].logo) {
            cell.imageContainer.image.alpha = 0
            
            cell.imageContainer.image.kf.setImage(with: imageURL, placeholder: nil, completionHandler: { (_) in
                UIView.animate(withDuration: 0.5) {
                    cell.imageContainer.image.alpha = 1.0
                }
            })
        }
        
        if membersCount != nil {
            cell.membersCount.text = "\(membersCount!) чел"
        } else {
            cell.membersCount.text = ""
            cell.membersCount.isHidden = true
        }
        
        return cell
    }
}
