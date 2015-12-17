//
//  Th ResponseCollectionSerializable.swift
//  Pods
//
//  Created by Tonghu_Yi on 12/16/15.
//
//

import Foundation

public protocol ThResponseCollectionSerializable  {
    static func collecitonByArry<T :ThResponseCollectionSerializable> (json: NSArray) -> [T]?
}