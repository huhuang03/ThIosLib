//
//  UIColorExtension.swift
//  Pods
//
//  Created by 文凡胡 on 1/16/16.
//
//

import Foundation

extension UIColor {
    // don't conside edage cases
    convenience init(string: String) {
        var str = string
        if string.hasPrefix("#") {
            str = string.substringFromIndex(string.startIndex.advancedBy(1))
        }
        
        let rString = str.substringToIndex(str.startIndex.advancedBy(2))
        let gString = str.substringWithRange(Range(start: str.startIndex.advancedBy(2), end: str.startIndex.advancedBy(4)))
        let bString = str.substringWithRange(Range(start: str.startIndex.advancedBy(4), end: str.startIndex.advancedBy(6)))
        
        let aInt = UInt8(strtoul(rString, nil, 16))
        let gInt = UInt8(strtoul(gString, nil, 16))
        let bInt = UInt8(strtoul(bString, nil, 16))
        
        
        self.init(
            red: CGFloat(aInt) / CGFloat(255),
            green: CGFloat(gInt) / CGFloat(255),
            blue: CGFloat(bInt) / CGFloat(255),
            alpha: CGFloat(1)
        )
    }
}
