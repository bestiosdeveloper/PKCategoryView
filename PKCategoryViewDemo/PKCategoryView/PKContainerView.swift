//
//  PKContainerView.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PKContainerViewDelegate: class {
    func categoryContainer(_ container: PKContainerView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int, withProgress progress: CGFloat)
    func categoryContainer(_ container: PKContainerView, didSwitchIndexTo toIndex: Int)
}

class PKContainerView: UIView {
    
    enum ScrollDirection {
        case backward
        case forward
        case none
    }
    
    
    //Mark:- Properties
    //MARK:- Private
    private var singlePageSize: CGSize {
        return bounds.size
    }
    
    private var previousOffset = CGPoint.zero
    
    private var willTransitionFromIndex: Int?
    private var willTransitionToIndex: Int?
    
    private var currentScrollDirection: ScrollDirection {
        if scrollView.contentOffset.x > previousOffset.x {
            //forward (inc)
            return .forward
        }
        else if scrollView.contentOffset.x < previousOffset.x {
            //backward (dec)
            return .backward
        }
        
        return .none
    }
    
    //MARK:- Public
    private(set) var childVCs: [UIViewController]
    private(set) weak var parentVC: UIViewController!
    private(set) lazy var scrollView: UIScrollView = UIScrollView(frame: self.bounds)
    weak var delegate: PKContainerViewDelegate?


    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        
        setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView(){
        
        self.scrollView.contentSize = CGSize(width: singlePageSize.width * CGFloat(childVCs.count), height: singlePageSize.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        
        for (idx, vc) in self.childVCs.enumerated() {
            vc.view.frame = CGRect(x: (singlePageSize.width * CGFloat(idx)), y: 0.0, width: singlePageSize.width, height: singlePageSize.height)
            self.scrollView.addSubview(vc.view)
        }
        
        self.addSubview(self.scrollView)
    }
    
    func selectPage(atIndex: Int, animated: Bool) {
        let newOffset: CGPoint = CGPoint(x: singlePageSize.width * CGFloat(atIndex), y: 0.0)
        self.scrollView.setContentOffset(newOffset, animated: animated)
    }
}


//MARK:-
//MARK:- Scroll view delegate methods
extension PKContainerView: UIScrollViewDelegate {
    
    private func handelScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        
        let upperBound = scrollView.contentSize.width - scrollView.bounds.width
        guard 0...upperBound ~= offset.x else {
            return
        }
        
        //progress calculation
        let reminder = offset.x.truncatingRemainder(dividingBy: scrollView.bounds.width)
        
        var progress: CGFloat = 0.0
        
        if reminder > 0 {
            
            progress = reminder / scrollView.bounds.width
            
            //page calculation
            if currentScrollDirection == .forward {
                //forward (inc)
                willTransitionFromIndex = Int(offset.x / scrollView.bounds.width)
                willTransitionToIndex = willTransitionFromIndex! + 1
            }
            else if currentScrollDirection == .backward {
                //backward (dec)
                willTransitionFromIndex = Int((offset.x + scrollView.bounds.width) / scrollView.bounds.width)
                willTransitionToIndex = willTransitionFromIndex! - 1
            }
        }
        else {
            
            let prevProgress = previousOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
            progress = (prevProgress > 0.5) ? 1.0 : 0.0
        }
        
        if currentScrollDirection == .backward {
            progress = (1.0 - progress)
        }
        
        previousOffset = scrollView.contentOffset
        
        if let frm = willTransitionFromIndex, let to = willTransitionToIndex {
            if progress == 1.0 {
                delegate?.categoryContainer(self, didSwitchIndexTo: to)
            }
            else {
                delegate?.categoryContainer(self, willSwitchIndexFrom: frm, to: to, withProgress: progress)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handelScroll(scrollView)
    }
}
