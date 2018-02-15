//
//  MenuView.swift
//  SwiftSliderMenu
//
//  Created by willard on 2017/11/27.
//  Copyright © 2017年 willard. All rights reserved.
//

import UIKit

protocol XibView {}

extension XibView where Self : UIView {
    static func instance<T: UIView>() -> T {
        let c = UINib(nibName: String(describing: self), bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0]

        return c as! T
    }
}

class MenuView: UIView, UITableViewDelegate, UITableViewDataSource, XibView {

    
    @IBOutlet weak var tableView: UITableView!
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "ViewController \(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIViewController()
        vc.title = "VC \(indexPath.row)"
       
        if let naviVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            vc.view.backgroundColor = .white
            naviVC.pushViewController(vc, animated: true)
            SliderMenuManager.shared.hiddenMenu()
        }
    }
    
  
}
