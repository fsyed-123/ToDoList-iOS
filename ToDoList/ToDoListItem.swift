//
//  ToDoListtItem.swift
//  ToDoList
//
//  Created by Faisal Syed on 2/5/19.
//  Copyright © 2019 Faisal Syed. All rights reserved.
//

import Foundation

public struct ToDoListItem: Codable {

    // Id
    let id: Int?

    // Title
    let title: String

    // Description
    let description: String
}
