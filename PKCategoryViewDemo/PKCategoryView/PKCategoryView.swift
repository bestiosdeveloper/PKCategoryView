//
//  PKCategoryView.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PKCategoryViewDelegate: class {
    func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int)
    func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int)
}

open class PKCategoryView: UIView {

    //Mark:- Properties
    //MARK:- Private
    public fileprivate(set) var navBar: PKCategoryNavBar!
    private var configuration: PKCategoryViewConfiguration
    private var categories: [PKCategoryItem]
    fileprivate weak var parentVC: UIViewController!
    private var childVCs: [UIViewController]
    private var containerView: PKContainerView!
    private var willSwitchDelegateCalledInProgress: Bool = false
    
    weak var delegate: PKCategoryViewDelegate?
    
    //Mark:- Life Cycle
    //MARK:-
    public init(frame: CGRect, categories: [PKCategoryItem], childVCs: [UIViewController], configuration: PKCategoryViewConfiguration, parentVC: UIViewController) {
        self.categories = categories
        self.configuration = configuration
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
                
        setupSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:- Subviews Setup
private extension PKCategoryView {
    func setupSubviews() {
        setupNavBar()
        setupContainerView()
    }
    
    func setupNavBar() {
        var barFrame = CGRect.zero
        if configuration.isEmbeddedToView {
            barFrame = CGRect(x: 0, y: 0, width: bounds.width, height: configuration.navBarHeight)
        }
        
        if navBar == nil {
            navBar = PKCategoryNavBar(frame: barFrame, categories: self.categories, configuration: self.configuration)
            navBar.delegate = self
            addSubview(navBar)
        }
        else {
            navBar.frame = barFrame
        }
    }
    
    func setupContainerView() {
        let containerY: CGFloat = configuration.isEmbeddedToView ? configuration.navBarHeight : 0.0
        let containerHeight: CGFloat = configuration.isEmbeddedToView ? bounds.height - configuration.navBarHeight : bounds.height
        let frame = CGRect(x: 0, y: containerY, width: bounds.width, height: containerHeight)
        
        if containerView == nil {
            containerView = PKContainerView(frame: frame, childVCs: childVCs, parentVC: parentVC)
            containerView.delegate = self
            addSubview(containerView)
        }
        else {
            containerView.frame = frame
        }
    }
}

//MARK:-
//MARK:- NavBar delegate methods
extension PKCategoryView: PKCategoryNavBarDelegate {
    func categoryNavBar(_ navBar: PKCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
        self.containerView.selectPage(atIndex: toIndex, animated: true)
    }
    
    func categoryNavBar(_ navBar: PKCategoryNavBar, didSwitchIndexTo toIndex: Int) {
    }
}

//MARK:-
//MARK:- Container view delegate methods
extension PKCategoryView: PKContainerViewDelegate {
    func categoryContainer(_ container: PKContainerView, didSwitchIndexTo toIndex: Int) {
        self.navBar.moveSelection(fromIndex: toIndex, to: toIndex, withProgress: 1.0)
        self.delegate?.categoryView(self, didSwitchIndexTo: toIndex)
        self.willSwitchDelegateCalledInProgress = false
    }
    
    func categoryContainer(_ container: PKContainerView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int, withProgress progress: CGFloat) {
        self.navBar.moveSelection(fromIndex: fromIndex, to: toIndex, withProgress: progress)
        if !self.willSwitchDelegateCalledInProgress {
            self.willSwitchDelegateCalledInProgress = true
            self.delegate?.categoryView(self, willSwitchIndexFrom: fromIndex, to: toIndex)
        }
    }
}
