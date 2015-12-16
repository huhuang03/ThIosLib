//
//  ThApp.swift
//  Pods
//
//  Created by Tonghu_Yi on 12/15/15.
//
//

import Foundation

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
