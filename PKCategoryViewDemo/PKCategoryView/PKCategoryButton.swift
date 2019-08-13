//
//  PKCategoryButton.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PKCategoryButton: UIButton {
    
    //Mark:- Properties
    //MARK:- Private
    private var configuration: PKCategoryViewConfiguration
    
    private var badgeLabel: UILabel = UILabel()
    
    private var _selectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _normalFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _highlightedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    //MARK:- Public
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            setFontAsState()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
            setFontAsState()
        }
    }
    
    var badgeCount: Int = 0 {
        didSet {
            updateBadgeCount()
        }
    }
    
    //Mark:- Life Cycle
    //MARK:-
    public init(frame: CGRect, configuration: PKCategoryViewConfiguration) {
        self.configuration = configuration
        
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Mark:- Methods
    //MARK:- Private
    private func initialSetup() {
        setupForBadge()
    }
    
    private func setupForBadge() {
        badgeLabel.isHidden = true
        badgeLabel.frame = CGRect(x: 0.0, y: 0.0, width: configuration.badgeDotSize.width, height: configuration.badgeDotSize.height)
        
        badgeLabel.backgroundColor = configuration.badgeBackgroundColor
        badgeLabel.layer.borderColor = configuration.badgeBorderColor.cgColor
        badgeLabel.layer.borderWidth = configuration.badgeBorderWidth
        badgeLabel.textColor = configuration.badgeTextColor
        badgeLabel.font = configuration.badgeTextFont
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2.0
        badgeLabel.layer.masksToBounds = true
        
        addSubview(badgeLabel)
    }
    
    private func setFontAsState() {
        if isSelected {
            self.titleLabel?.font = _selectedFont
        }
        else if isHighlighted {
            self.titleLabel?.font = _highlightedFont
        }
        else {
            self.titleLabel?.font = _normalFont
        }
    }
    
    //MARK:- Public
    func setTitleFont(font: UIFont, for state: UIControl.State) {
        if state == .normal {
            _normalFont = font
        }
        else if state == .highlighted {
            _highlightedFont = font
        }
        else {
            _selectedFont = font
        }
    }

    func updateBadgeCount() {
        let textWidth = self.textSizeCount(forString: (titleLabel?.text ?? "b"), withFont: titleLabel?.font ?? _normalFont, bundingSize: frame.size).width
        let extraWidthSpace = (frame.size.width - textWidth) / 2.0
        
        let extraHeightSpace = (frame.size.height - (titleLabel?.font ?? _normalFont).lineHeight) / 4.0
        
        badgeLabel.frame.origin.x = textWidth + extraWidthSpace + 2.0
        badgeLabel.frame.origin.y = extraHeightSpace //- badgeLabel.frame.size.height
        
        if configuration.shouldShowBadgeCount {
            badgeLabel.frame.origin.y = 0
            badgeLabel.text = (badgeCount > configuration.maxBadgeCount) ? "\(configuration.maxBadgeCount)+" : "\(badgeCount)"
            let height = (badgeLabel.font ?? _normalFont).lineHeight + configuration.badgeInset.top + configuration.badgeInset.bottom
            badgeLabel.frame.size.height = height
            let width = self.textSizeCount(forString: (badgeLabel.text ?? "b"), withFont: badgeLabel.font ?? _normalFont, bundingSize: CGSize(width: 10000.0, height: badgeLabel.frame.height)).width + configuration.badgeInset.left + configuration.badgeInset.right
            
            badgeLabel.frame.size.width = max(height, width)
            badgeLabel.textAlignment = .center
            badgeLabel.layer.cornerRadius = height / 2.0
        }
        
        badgeLabel.isHidden = badgeCount == 0
    }
    
    private func textSizeCount(forString: String, withFont font: UIFont, bundingSize size: CGSize) -> CGSize {
        let mutableParagraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: mutableParagraphStyle]
        let tempStr = NSString(string: forString)
        
        let rect: CGRect = tempStr.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let height = ceilf(Float(rect.size.height))
        let width = ceilf(Float(rect.size.width))
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
}
