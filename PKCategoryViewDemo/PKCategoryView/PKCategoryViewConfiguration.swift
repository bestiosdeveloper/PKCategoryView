//
//  PKCategoryViewConfiguration.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

public struct PKCategoryViewConfiguration {
    
    public var navBarHeight: CGFloat = 44.0
    
    public var navBarContentInset: UIEdgeInsets = .zero
    
    public var contentInset: UIEdgeInsets = .zero
    
    /// The paddings inserted before/after a PKCategoryItem's content.
    /// Note: this padding attribute is included into the touch area for each categoryItem.
    public var itemPadding: CGFloat = 8.0
    
    public var isNavBarScrollEnabled = false
    
    public var defaultFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    public var selectedFont: UIFont = UIFont.systemFont(ofSize: 17.0)
    public var showTransitionAnimation = true
    public var showBarSelectionAnimation = true
    
    
    /// PKCategoryItem normal color. Use RGB channels!!!
    public var normalColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    /// PKCategoryItem selected color. Use RGB channels!!!
    public var selectedColor = #colorLiteral(red: 0.9568627451, green: 0.6784313725, blue: 0.3843137255, alpha: 1)
    
    /// The space between each PKCategoryItem
    public var interItemSpace: CGFloat = 20.0
    
    
    public var showBottomSeparator = true
    public var bottomSeparatorColor = UIColor.lightGray
    
    /// The 'underscore' indicator following PKCategoryItems.
    public var showIndicator = true
    
    public var indicatorHeight:CGFloat = 2.0
    public var indicatorColor:UIColor = #colorLiteral(red: 0.9568627451, green: 0.6784313725, blue: 0.3843137255, alpha: 1)
    
    
    //##################
    
    //###### Badge related
    /// The default bgMaskView's background color.
    /// It doesn't have to use RGB channels.
    public var badgeBackgroundColor = UIColor.red
    public var badgeTextColor = UIColor.white
    public var badgeDotSize = CGSize(width: 8.0, height: 8.0)
    public var badgeTextFont = UIFont.systemFont(ofSize: 12.0)
    public var badgeInset: UIEdgeInsets = UIEdgeInsets(top: 1.0, left: 3.0, bottom: 1.0, right: 3.0)
    public var maxBadgeCount: Int = 99
    public var shouldShowBadgeCount: Bool = false
    
    public var badgeBorderWidth: CGFloat = 0.0
    public var badgeBorderColor = UIColor.clear
    
    //##################
    
    
    /// Should the navBar be embedded into categoryView. If not, you should position it manually somewhere. You can embedded it into a native narBar's titleView if you want.
    public var isEmbeddedToView = true
    
    public init() {}
    
}


public struct PKCategoryItem {
    public var title: String?
    public var normalImage: UIImage?
    public var selectedImage: UIImage?
    
    public init(title: String?, normalImage: UIImage?, selectedImage: UIImage?) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
    }
}
