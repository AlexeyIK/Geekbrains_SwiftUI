//
//  MyGroupsList.swift
//  iOS_UI_practice1
//
//  Created by Alex on 02.12.2019.
//  Copyright © 2019 Alexey Kuznetsov. All rights reserved.
//

import UIKit

class MyGroupsList: UITableViewController {
    
    override func loadView() {
        super.loadView()
        
        // Инициализируем списки групп
        GroupsData.updateList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GroupsData.myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        
        cell.caption.text = GroupsData.myGroups[indexPath.row].groupName
        cell.subTitle.text = GroupsData.myGroups[indexPath.row].groupSubstring
        cell.groupImage.image = UIImage(named: GroupsData.myGroups[indexPath.row].imagePath!)
        cell.numOfMembers.text = "" // пустой текст, чтобы не отображать количество людей в группах, в которых мы состоим

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let targetGroup = GroupsData.myGroups[indexPath.row]
        let index = GroupsData.testList.firstIndex(where: {$0 === targetGroup})
        
        if editingStyle == .delete && index != nil {
            GroupsData.testList[index!].isMeInGroup = false
            GroupsData.updateList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        
    }
}
