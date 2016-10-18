//
//  ViewController.swift
//  TextKit
//
//  Created by yao wei on 16/10/18.
//  Copyright © 2016年 yao wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var YWLabel: YWLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        YWLabel.text = "爱我请点http://www.jianshu.com";
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

