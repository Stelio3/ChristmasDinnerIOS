//
//  Repository.swift
//  Christmas dinner
//
//  Created by PABLO HERNANDEZ JIMENEZ on 9/1/19.
//  Copyright © 2019 PABLO HERNANDEZ JIMENEZ. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(identifier: String) -> T?
    func create(a: T) -> Bool
    func update(a: T) -> Bool
    func delete(a: T) -> Bool
}
