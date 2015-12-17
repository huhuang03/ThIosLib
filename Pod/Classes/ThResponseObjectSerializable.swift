//
//  ThResponseObjectSerializable.swift
//  Pods
//
//  Created by Tonghu_Yi on 12/15/15.
//
//

import Foundation

/*
    能通过jsonResponse序列化的对象
*/
public protocol ThResponseObjectSerializable {
    static func byJson(json: NSDictionary) -> Self?
}
