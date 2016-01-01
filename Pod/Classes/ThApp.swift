//
//  ThApp.swift
//  Pods
//
//  Created by Tonghu_Yi on 12/15/15.
//
//

import Foundation
import Alamofire

public class ThApp {
    static var HAS_INIT = false;
    
    public static func setUp() {
        if !HAS_INIT {
            HAS_INIT = true
            setUpInternal()
        }
    }
    
    private static func setUpInternal() {
    }
    
}

extension NSObject: ThResponseObjectSerializable {
    public static func byJson(json: NSDictionary) -> Self? {
        let objc = self.init()
        var count:UInt32 = 0
        let properties = class_copyPropertyList(self.classForCoder(), &count)
        
        for i in 0..<Int(count) {
            let property = properties[i]
            
            let keys = NSString(CString: property_getName(property), encoding: NSUTF8StringEncoding)!
            
            let types = NSString(CString: property_getAttributes(property), encoding: NSUTF8StringEncoding)!
            
            let value = json[keys]
            
            let CustomPrefix = types.substringFromIndex("T@".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            
            var CustomValueName:String?
            
            if !CustomPrefix.hasPrefix(",") {
                CustomValueName = CustomPrefix.componentsSeparatedByString(",").first!
            }
            
            if let value = value {
                if value is [String: AnyObject] {
                    if let className = swiftClassFromString(CustomValueName!) {
                        let CustomValueObject = className.byJson(value as! [String:AnyObject])
                        objc.setValue(CustomValueObject, forKey: keys as String)
                    }
                }
            } else {
                if let value = value as? NSNumber {
                   objc.setValue("\(value)", forKeyPath:keys as String)
                } else {
                    objc.setValue(value!, forKeyPath:keys as String)
                }
            }
        }
        free(properties)
        return objc
    }
    
    private class func swiftClassFromString(className: String) -> AnyClass! {
        if  let appName: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String? {
            
            if className.hasPrefix("\""){
                
                // "\"User\""
                var rang = (className as NSString).substringFromIndex("\"".lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
                // 类型字符串截取
                let length = rang.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                // User\""
                rang = (rang as NSString).substringToIndex(length.hashValue-1)
                return NSClassFromString("\(appName).\(rang)")
                
            }
            
        }
        
        return nil;
        
    }

}

extension NSObject: ThResponseCollectionSerializable {
    public static func collecitonByArry<T : ThResponseCollectionSerializable>(json: NSArray) -> [T]? {
        var rst = [T]()
        for item in json {
            if let item = item as? NSDictionary, obj = byJson(item) {
                rst.append(obj as! T)
            }
        }
        return rst
    }

}

extension Request {
    public func responseObject<T: ThResponseObjectSerializable>(completionHanlder: Response<T, NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> {
            request, response, data, error in
            guard error == nil else {return .Failure(error!)}
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            switch result {
            case .Success(let value):
                if let
                    JSON = value as? NSDictionary,
                    responseObject = T.byJson(JSON)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHanlder)
    }
    
    public func responseObjectCollection<T: ThResponseCollectionSerializable>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> {
            request, response, data, error in
            guard error == nil else {return .Failure(error!)}
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            switch result {
            case .Success(let value):
                if let
                JSON = value as? NSArray
                , rst:[T] = T.collecitonByArry(JSON)
                {
                    return .Success(rst)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
            
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}