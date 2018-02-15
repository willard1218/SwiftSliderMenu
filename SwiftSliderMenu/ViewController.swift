//
//  ViewController.swift
//  SwiftSliderMenu
//
//  Created by willard on 2018/2/15.
//  Copyright © 2018年 willard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func menuDidPressed(_ sender: UIBarButtonItem) {
        SliderMenuManager.shared.showMenu()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


