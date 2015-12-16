//
//  ViewController.swift
//  ThIosLib
//
//  Created by huhuang03 on 12/11/2015.
//  Copyright (c) 2015 huhuang03. All rights reserved.
//

import UIKit
import Alamofire
import ThIosLib

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ThTest.sayHello()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

