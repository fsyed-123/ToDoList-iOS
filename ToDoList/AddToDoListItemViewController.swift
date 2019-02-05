//
//  AddToDoListItemViewController.swift
//  ToDoList
//
//  Created by Faisal Syed on 2/5/19.
//  Copyright © 2019 Faisal Syed. All rights reserved.
//

import UIKit

final class AddToDoListItemViewController: UIViewController {

    // MARK: - Properties
    internal var delegate: AddToDoListItemDelegate?

    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var titleTextField: UITextField!
    @IBOutlet fileprivate weak var descriptionTextField: UITextField!
    @IBOutlet fileprivate  weak var spinner: UIActivityIndicatorView! {
        didSet {
            spinner.isHidden = true
        }
    }

    // MARK: - Storyboard Actions

    @IBAction func addTapped(_ sender: Any) {

        // Start spinner
        spinner.isHidden = false
        spinner.startAnimating()

        guard let title = titleTextField.text else {
            // Display error
            return
        }

        guard let description = descriptionTextField.text else {
            return
        }

        // POST new to do list item
        let todoListItem: ToDoListItem = ToDoListItem(id: nil, title: title, description: description)
        do {
            let decodedItem = try JSONEncoder().encode(todoListItem)
            let urlString: String = "http://localhost:3003/todolist_create"
            if let url: URL = URL(string: urlString) {

                // Create POST request
                var urlRequest: URLRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = decodedItem
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

                // Trigger request
                let session: URLSessionDataTask = URLSession.shared.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
                    if let error = error {
                        self.errorAdding(errorMessage: error.localizedDescription)
                        return
                    } else {
                        self.finishAdding()
                    }
                }
                session.resume()
            }
        } catch let err {
            print("Error encoding item \(err.localizedDescription)")
            return
        }
    }

    // MARK: - UI Updates

    fileprivate func finishAdding() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
            self.dismiss(animated: true, completion: {
                self.delegate?.didFinishAddingToDoListItem()
            })
        }
    }

    fileprivate func errorAdding(errorMessage: String) {
        DispatchQueue.main.async {
            let alertController: UIAlertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - Add To Do List Item Delegate

protocol AddToDoListItemDelegate {
    // Called when we complete adding a to do list item
    func didFinishAddingToDoListItem()
}
