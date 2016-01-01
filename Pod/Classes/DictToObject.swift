//
//  DictToObject.swift
//  Pods
//
//  Created by 文凡胡 on 1/1/16.
//
//

import UIKit

public class DictToObject: NSObject {
    required public init(dict: [String: AnyObject]) {
        super.init()
        var count:UInt32 = 0
        let properties = class_copyPropertyList(self.dynamicType, &count)
        for i in 0..<Int(count) {
            let p = properties[i]
            let attribute = NSString(CString: property_getAttributes(p), encoding: NSUTF8StringEncoding)!
            
            //attrubute: T@"_TtC14__lldb_expr_847Address",N,&,Vaddress
            print(attribute)
            let attributeString = attribute as String
            let attrName = attributeString.characters.split(",").map(String.init).last!.substringFromIndex(" ".startIndex.advancedBy(1))
            let value = dict[attrName]
            if attribute.hasPrefix("T@\"_TtC") {
                let tempClassName = attributeString.characters.split(",").map(String.init).first!
                let className = tempClassName.substringWithRange(Range(start: tempClassName.startIndex.advancedBy(3), end: tempClassName.endIndex.advancedBy(-1)))
                print("\(className)")
                if value is [String: AnyObject] {
                    let tempDict = (NSClassFromString(className) as! DictToObject.Type).init(dict: value as! [String: AnyObject])
                    setValue(tempDict, forKey: attrName)
                } else if value is NSArray {
                    let tempDict = (NSClassFromString(className) as! DictToObject.Type).objectArrayWithKeyValueArray(value as! [[String: AnyObject]])
                    setValue(tempDict, forKey: attrName)
                }
            } else {
                if value is NSNumber {
                    setValue("\(value)", forKey: attrName)
                } else {
                    setValue(value, forKey: attrName)
                }
            }
        }
        
    }
    
    class func objectArrayWithKeyValueArray(keyValueArray: [[String: AnyObject]]) -> [AnyObject]? {
        var rst = [AnyObject]()
        for dict in keyValueArray {
            rst.append(self.init(dict: dict))
        }
        return rst
    }
}
