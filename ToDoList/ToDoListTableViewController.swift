//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Faisal Syed on 2/5/19.
//  Copyright © 2019 Faisal Syed. All rights reserved.
//

import UIKit

final class ToDoListTableViewController: UITableViewController {

    // MARK: - Properties
    private var todoListItems: [ToDoListItem]?
    fileprivate lazy var todoListRepo: ToDoListRepository = {
        return ToDoListRepository(delegate: self)
    }()
    fileprivate lazy var addToDoListItemVC: AddToDoListItemViewController? = {
        let todoListItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addToDoItemVC") as? AddToDoListItemViewController
        todoListItemVC?.delegate = self
        return todoListItemVC
    }()

    // MARK: - View Lifecycle

    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do"
        self.tableView.delegate = self
    }

    override internal func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListRepo.getToDoListItems()
    }

    // MARK: - Storyboard Actions
    @IBAction func addNewTapped(_ sender: Any) {
        DispatchQueue.main.async {
            if let addVC = self.addToDoListItemVC {
                self.present(addVC, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source

extension ToDoListTableViewController {

    // MARK: - Table view data source

    override internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.todoListItems {
            return items.count
        } else {
            return 0
        }
    }

    override internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)

        if let currentItem: ToDoListItem = self.todoListItems?[indexPath.row] {
            cell.textLabel?.text = currentItem.title
            cell.detailTextLabel?.text = currentItem.description
        } else {
            cell.textLabel?.text = "Error - no to do list items found"
        }

        return cell
    }
}

// MARK: - Data Fetched from the Repo

extension ToDoListTableViewController: ToDoListDelegate {

    func didFetchToDoListItems(items: [ToDoListItem]) {
        self.todoListItems = items

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func didFailToFetchToDoListItems() {
        print("Dangit! We can't display any todo items")
    }
}

extension ToDoListTableViewController: AddToDoListItemDelegate {
    func didFinishAddingToDoListItem() {
        todoListRepo.getToDoListItems()
    }
}
