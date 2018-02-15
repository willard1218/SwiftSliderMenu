//
//  AppDelegate.swift
//  SwiftSliderMenu
//
//  Created by willard on 2018/2/15.
//  Copyright © 2018年 willard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? 


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.makeKeyAndVisible()
        
        if let naviVC = window?.rootViewController as? UINavigationController {
            SliderMenuManager.shared.setup(inView: naviVC.view) { () -> UIView in
                return MenuView.instance()
            }
        }
        
        return true
    }

   
}

