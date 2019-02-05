//
//  ToDoListRepository.swift
//  ToDoList
//
//  Created by Faisal Syed on 2/5/19.
//  Copyright © 2019 Faisal Syed. All rights reserved.
//

import Foundation

public class ToDoListRepository {

    // MARK: - Properties
    internal weak var delegate: ToDoListDelegate?

    // MARK: - Init
    init(delegate: ToDoListDelegate) {
        self.delegate = delegate
    }

    internal func getToDoListItems() {

        // Fetch To Do List Items
        let urlString: String = "http://localhost:3003/todolistitems"
        if let url: URL = URL(string: urlString) {
            let session: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if let error = error {
                    print("Error fetching todo list items \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data from response")
                    return
                }

                do {
                    let todoListItems = try JSONDecoder().decode([ToDoListItem].self, from: data)
                    self.delegate?.didFetchToDoListItems(items: todoListItems)
                } catch let err {
                    print("Error decoding response \(err.localizedDescription)")
                    self.delegate?.didFailToFetchToDoListItems()
                }
            }
            session.resume()
        }
    }
}

public protocol ToDoListDelegate: class {

    // Called when we successfully receive to do list items
    func didFetchToDoListItems(items: [ToDoListItem])

    // Called when we fail to fetch to do list items
    func didFailToFetchToDoListItems()
}
