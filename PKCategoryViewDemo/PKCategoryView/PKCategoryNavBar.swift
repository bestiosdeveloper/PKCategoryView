//
//  PKCategoryNavBar.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol PKCategoryNavBarDelegate: class {
    func categoryNavBar(_ navBar: PKCategoryNavBar, willSwitchIndexFrom fromIndex: Int, to toIndex: Int)
    func categoryNavBar(_ navBar: PKCategoryNavBar, didSwitchIndexTo toIndex: Int)
}

public class PKCategoryNavBar: UIView {
    
    //Mark:- Properties
    //MARK:- Private
    public fileprivate(set) var navBar: PKCategoryNavBar!
    private var configuration: PKCategoryViewConfiguration
    private var categories: [PKCategoryItem]
    
    fileprivate lazy var scrollView: UIScrollView = UIScrollView(frame: self.bounds)
    
    // this button keeps track of which button being tapped previously
    fileprivate weak var previousButton: PKCategoryButton?
    
    fileprivate lazy var buttonHeight: CGFloat = self.bounds.height
    
    fileprivate lazy var buttons = [PKCategoryButton]()
    
    // this tag relects any changes in VC switching
    fileprivate var currentButtonTag: Int = 0
    
    private var startingOffset: CGPoint?
    private var startingIndicatorCenter: CGPoint?
    private var shouldMoveNavContent: Bool = false
    
    fileprivate lazy var indicator: UIView = {
        let view = UIView()
        view.frame.size.height = self.configuration.indicatorHeight
        view.frame.origin.y = self.bounds.height - self.configuration.indicatorHeight
        view.backgroundColor = self.configuration.indicatorColor
        self.scrollView.addSubview(view)
        return view
    }()
    
    //MARK:- Public
    weak var delegate: PKCategoryNavBarDelegate?
    
    //Mark:- Life Cycle
    //MARK:-
    public init(frame: CGRect, categories: [PKCategoryItem], configuration: PKCategoryViewConfiguration) {
        self.categories = categories
        self.configuration = configuration
        
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBadge(count: Int, atIndex index: Int) {
        self.buttons[index].badgeCount = count
    }
}

//MARK:- Subviews Setup
private extension PKCategoryNavBar {
    
    func setupSubviews() {
        setupBottomSeparator()
        setupScrollView()
        addButtons()
        setupIndicator()
    }
    
    func setupBottomSeparator() {
        guard configuration.showBottomSeparator else {
            return
        }
        let separator = UIView()
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        separator.backgroundColor = configuration.bottomSeparatorColor
        self.addSubview(separator)
    }
    
    func setupScrollView(){
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = configuration.isNavBarScrollEnabled
        scrollView.contentInset = configuration.contentInset
        addSubview(scrollView)
    }
    
    
    func setup(_ btn: PKCategoryButton, with item: PKCategoryItem, atIndex index:Int) {
        btn.imageView?.contentMode = .scaleAspectFill
        btn.tag = index
        btn.isHighlighted = false
        if let itemTitle = item.title {
            btn.setTitle(itemTitle, for: .normal)
            btn.setTitleColor(configuration.selectedColor, for: .selected)
            btn.setTitleColor(configuration.normalColor, for: .normal)
            
            btn.titleLabel?.textAlignment = .center
            btn.setTitleFont(font: configuration.defaultFont, for: .normal)
            btn.setTitleFont(font: configuration.selectedFont, for: .selected)
            if index == 0 {
                btn.isSelected = true
                previousButton = btn
            }
            else {
                btn.isSelected = false
            }
        }
        
        if let normalImage = item.normalImage {
            btn.setImage(normalImage, for: .normal)
        }
        
        if let selectedImage = item.selectedImage {
            btn.setImage(selectedImage, for: .selected)
        }
    }
    
    func addButtons() {
        for i in 0..<categories.count {
            let btn = PKCategoryButton(frame: .zero, configuration: self.configuration)
            let item = categories[i]
            setup(btn, with: item, atIndex: i)
            
            var x: CGFloat = 0.0
            let y: CGFloat = 0.0
            var width: CGFloat = 0.0
            let height = self.buttonHeight
            let textWidth: CGFloat = btn.intrinsicContentSize.width
            
            
            
            if configuration.isNavBarScrollEnabled {
                // scrollabel, each label has its own width according to its text
                width = textWidth + configuration.itemPadding * 2
                if i > 0 {
                    let previousBtn = buttons[i - 1]
                    x = previousBtn.frame.maxX + configuration.interItemSpace
                }
                // special adjustment for the first button
                if i == 0 {
                    x = configuration.interItemSpace * 0.5
                }
            }
            else {
                width = self.bounds.width / CGFloat(categories.count)
                
                if i > 0 {
                    x = width * CGFloat(i)
                }
            }
            
            btn.frame = CGRect(x: x, y: y, width: width, height: height)
            btn.addTarget(self, action: #selector(titleBtnTapped(_:)), for: .touchUpInside)
            buttons.append(btn)
            
            scrollView.addSubview(btn)
            
            let contentWidth:CGFloat = buttons.last!.frame.maxX + configuration.interItemSpace * 0.5
            let contentHeight:CGFloat = self.bounds.height
            scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
            
        }
    }
    
    func setupIndicator() {
        guard configuration.showIndicator else {
            return
        }
        let defaultBtn = buttons[0]
        let width: CGFloat = defaultBtn.intrinsicContentSize.width
        indicator.frame.size.width = width
        indicator.center.x = defaultBtn.center.x
    }
}

extension PKCategoryNavBar {
    private func isEnoughSpaceToMove(fromIndex fromIdx: Int, to toIdx: Int) -> Bool {
        let requiredSpace: CGFloat = buttons[toIdx].intrinsicContentSize.width + (configuration.interItemSpace * 0.5)
        
        let avialableSpace = bounds.width - (indicator.frame.origin.x + indicator.frame.size.width + (configuration.interItemSpace * 0.5))
        
        return requiredSpace < avialableSpace
    }
    
    func moveSelection(fromIndex fromIdx: Int, to toIdx: Int, withProgress progress: CGFloat) {
        guard fromIdx < buttons.count, toIdx < buttons.count else {
            return
        }
        
        if progress == 1.0 || progress == 0.0 {
            //move to toIndex
            self.handelTapFor(buttons[toIdx])
            self.startingOffset = nil
            self.startingIndicatorCenter = nil
        }
        else if progress > 0.0 {
            //animate according to the progress
            
            if configuration.isNavBarScrollEnabled, self.shouldMoveNavContent {
                if self.startingOffset == nil {
                    self.startingOffset = self.scrollView.contentOffset
                    self.startingIndicatorCenter = self.indicator.frame.origin
                }
                //stuck the indicator on same position, move the navBar content
                var addOffset = buttons[toIdx].frame.size.width * progress
                addOffset *= ((fromIdx > toIdx) ? -1.0 : 1.0)
                
                let newOffset = CGPoint(x: self.startingOffset!.x + addOffset, y: 0.0)
                self.scrollView.setContentOffset(newOffset, animated: false)
            }
            else {
                //if enough space available then move indicator, stuck navBar content
                let fromX: CGFloat = buttons[fromIdx].frame.origin.x + ((buttons[fromIdx].frame.size.width - buttons[fromIdx].intrinsicContentSize.width) / 2.0)
                let toX: CGFloat = buttons[toIdx].frame.origin.x + ((buttons[toIdx].frame.size.width - buttons[toIdx].intrinsicContentSize.width) / 2.0)
                let dX: CGFloat = toX - fromX
                let prgX: CGFloat = fromX + (dX * progress)
                
                let dWidth: CGFloat = buttons[toIdx].intrinsicContentSize.width - buttons[fromIdx].intrinsicContentSize.width
                let prgWidth: CGFloat = buttons[fromIdx].intrinsicContentSize.width + (dWidth * progress)
                
                self.indicator.frame = CGRect(x: prgX, y: self.indicator.frame.origin.y, width: prgWidth, height: self.indicator.frame.size.height)
            }
        }
    }
    
    func scrollToCenter(currentBtn: PKCategoryButton, animated: Bool = true) {
        guard configuration.isNavBarScrollEnabled else {
            return
        }
        
        var centerX = currentBtn.center.x - scrollView.bounds.width * 0.5
        if centerX < 0.0 {
            // for labels positioned on the left side of scrollView.bounds.width * 0.5
            centerX = 0.0
            
        }
        
        // the x position for the last screen of the scroll
        let maxLeftEdge = scrollView.contentSize.width - bounds.width
        if centerX > maxLeftEdge{
            centerX = maxLeftEdge
        }
        scrollView.setContentOffset(CGPoint(x: centerX, y: 0.0), animated: animated)
    }
}


//MARK:- Event Handling
private extension PKCategoryNavBar {
    private func handelTapFor(_ btn: PKCategoryButton, shouldCallDelegate: Bool = false) {
        
        guard let prevBtn = previousButton, btn.tag != prevBtn.tag else {
            // prevent mutiple tapping on the same button
            return
        }
        
        previousButton?.isSelected = false
        btn.isSelected = true
        previousButton = btn
        
        if shouldCallDelegate {
            delegate?.categoryNavBar(self, willSwitchIndexFrom: prevBtn.tag, to: btn.tag)
        }
        
        self.handleIndicator(currentBtn: btn)
        
        if shouldCallDelegate {
            delegate?.categoryNavBar(self, didSwitchIndexTo: btn.tag)
        }
    }
    
    @objc func titleBtnTapped(_ btn: PKCategoryButton) {
        self.handelTapFor(btn, shouldCallDelegate: true)
    }
    
    func handleIndicator(currentBtn: PKCategoryButton) {
        guard configuration.showIndicator else {
            return
        }
        
        defer {
            if configuration.isNavBarScrollEnabled {
                
                self.shouldMoveNavContent = false
                
                let lowerBound = self.scrollView.frame.size.width * 0.5
                let upperBound = self.scrollView.contentSize.width - lowerBound
                
                self.shouldMoveNavContent = false
                
                if lowerBound < upperBound, lowerBound...upperBound ~= self.indicator.center.x {
                    self.shouldMoveNavContent = true
                    self.scrollToCenter(currentBtn: currentBtn, animated: true)
                }
                else if indicator.center.x < lowerBound {
                    //set scroll view to start
                    self.scrollView.setContentOffset(CGPoint.zero, animated: true)
                }
                else if lowerBound < upperBound, indicator.center.x > upperBound {
                    //set scroll view to end
                    self.scrollView.setContentOffset(CGPoint(x: (upperBound - lowerBound), y: 0.0), animated: true)
                }
            }
        }
        
        let width = currentBtn.intrinsicContentSize.width
        if configuration.showBarSelectionAnimation {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.indicator.frame.size.width = width
                self?.indicator.center.x = currentBtn.center.x
            }
        } else {
            self.indicator.frame.size.width = width
            self.indicator.center.x = currentBtn.center.x
        }
    }
}
