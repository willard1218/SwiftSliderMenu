//
//  SliderMenuManager.swift
//  SwiftSliderMenu
//
//  Created by willard on 2017/11/22.
//  Copyright © 2017年 willard. All rights reserved.
//

import Foundation
import UIKit

public typealias MenuViewCallBack = (_ view: UIView) -> ()

@objc
public class SliderMenuManager : NSObject {
    public enum MenuPosition: Int
    {
        case left
        case right
    }

    
    static let shared = SliderMenuManager()
    
    public var isMenuViewBelowStatusBar : Bool = false
    public var durationOfShowMenu = 0.25
    public var durationOfHiddenMenu = 0.25
    public var paddingMenuBottom: CGFloat = 0

    
    private var baseMenuView : UIView = UIView()
    private weak var menuView : UIView!
    private weak var blackView : UIButton!
    
    private var hasShowMenu = false
    private var superView : UIView!
    
    private let widthOfBaseMenuView : CGFloat = 300
    private let cornerRadiusOfBaseMenuView : CGFloat = 0
    private var statusBarHeight : CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    
    private var yOffsetOfMenuView : CGFloat {
        get {
            if isMenuViewBelowStatusBar {
                return statusBarHeight
            }
            else {
                return 0
            }
        }
    }
    
    private var heightOfMenuView : CGFloat {
        get {
            if #available(iOS 11.0, *) {
                let bottomPadding = superView.safeAreaInsets.bottom
                
                return UIScreen.main.bounds.height - yOffsetOfMenuView - bottomPadding - paddingMenuBottom
            }
            return UIScreen.main.bounds.height - yOffsetOfMenuView - paddingMenuBottom
        }
    }
    
 
    public var menuViewPosition : MenuPosition = .left {
        didSet {
            let newFrameOfBaseMenuView : CGRect = frameOfInvisiableMenu()
            baseMenuView.frame = newFrameOfBaseMenuView
        }
    }
    
   
    private override init() {
        super.init()
        superView = UIApplication.shared.keyWindow!
        setupViews()
    }
    
    
    func setup(inView: UIView, menuViewBlock: () -> UIView) {
        if superView != nil {
            baseMenuView.removeFromSuperview()
            superView = nil
        }
        
        superView = inView
        setupViews()
        menuView = menuViewBlock()
        
        baseMenuView.addSubview(menuView)
        menuView.frame = baseMenuView.bounds
        
        menuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        menuViewPosition = .left
    }
    
   
    private func setupViews() {
        baseMenuView.backgroundColor = UIColor.clear
       
        superView.addSubview(baseMenuView)
        baseMenuView.autoresizingMask = [.flexibleHeight]
        baseMenuView.layer.cornerRadius = cornerRadiusOfBaseMenuView
        baseMenuView.layer.masksToBounds = true
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(baseMenuViewLeftSwipe))
        leftSwipeGesture.direction = .left
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(baseMenuViewRightSwipe))
        rightSwipeGesture.direction = .right
        baseMenuView.addGestureRecognizer(leftSwipeGesture)
        baseMenuView.addGestureRecognizer(rightSwipeGesture)
        
        
        let bv = UIButton(type: .custom)
        bv.frame = UIScreen.main.bounds
        bv.isHidden = true
        
        bv.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        bv.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bv.addTarget(self, action: #selector(blackViewDidPress), for: .touchUpInside)
        superView.addSubview(bv)
        blackView = bv
    }
    

    private func frameOfVisiableMenu() -> CGRect {
        let bounds = UIScreen.main.bounds
        
        switch menuViewPosition {
        case .left:
            return CGRect(x: 0-cornerRadiusOfBaseMenuView, y: yOffsetOfMenuView, width: self.widthOfBaseMenuView, height: self.heightOfMenuView)
        case .right:
            return CGRect(x: bounds.size.width - widthOfBaseMenuView + cornerRadiusOfBaseMenuView, y: yOffsetOfMenuView, width: self.widthOfBaseMenuView, height: self.heightOfMenuView)
        }
    }
    
    private func frameOfInvisiableMenu() -> CGRect {
        let bounds = UIScreen.main.bounds
        
        switch menuViewPosition {
        case .left:
            return CGRect(x: -widthOfBaseMenuView, y: yOffsetOfMenuView, width: self.widthOfBaseMenuView, height: self.heightOfMenuView)
        case .right:
            return CGRect(x: bounds.size.width, y: yOffsetOfMenuView, width: self.widthOfBaseMenuView, height: self.heightOfMenuView)
        }
    }
    
    @objc
    private func baseMenuViewLeftSwipe() {
        if menuViewPosition == .right {
            return
        }
    
        changeNextState()
    }
    
    @objc
    private func baseMenuViewRightSwipe() {
        if menuViewPosition == .left {
            return
        }
        
        changeNextState()
    }
    
    @objc
    private func blackViewDidPress() {
        changeNextState()
    }
    

    
    public func changeNextState() {
        if hasShowMenu {
            hiddenMenu()
        }
        else {
            showMenu()
        }
    }
  
  
    
    open func showMenu(willShow:MenuViewCallBack? = nil, didShow:MenuViewCallBack? = nil) {
        let newFrame = frameOfVisiableMenu()
        
        superView.bringSubview(toFront: baseMenuView)
        
        self.blackView.isHidden = false
        self.blackView.alpha = 0
        
        willShow?(menuView)
        

        UIView.animate(withDuration: durationOfShowMenu, animations: {
            self.baseMenuView.frame = newFrame
            self.blackView.alpha = 1
        }) { (success) in
            self.hasShowMenu = true
            didShow?(self.menuView)
        }
    }
    
    public func hiddenMenu(willHidden:MenuViewCallBack? = nil, didHidden:MenuViewCallBack? = nil) {
        let newFrame = frameOfInvisiableMenu()
        willHidden?(menuView)
        
        
        UIView.animate(withDuration: durationOfHiddenMenu, animations: {
            self.baseMenuView.frame = newFrame
            self.blackView.alpha = 0
        }) { (success) in
            self.blackView.isHidden = true
            self.hasShowMenu = false
            didHidden?(self.menuView)
        }
    }
}
