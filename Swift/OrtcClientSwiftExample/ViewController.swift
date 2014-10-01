//
//  ViewController.swift
//  OrtcClientSwiftExample
//
//  Created by Joao Caixinha on 01/10/14.
//  Copyright (c) 2014 Internet Business Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var ortcHandler: OrtcHandler = OrtcHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ortcHandler.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

