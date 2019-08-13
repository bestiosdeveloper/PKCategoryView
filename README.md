# PKCategoryView

[![CocoaPods](https://img.shields.io/cocoapods/p/FaveButton.svg)](https://cocoapods.org/pods/PKCategoryView)
[![codebeat badge](https://codebeat.co/badges/580517f8-efc8-4d20-89aa-900531610144)](https://codebeat.co/projects/github-com-bestiosdeveloper-pkcategoryview-master)

PKCategoryView helps you to create dynamic UITabBarController, that will manage be managed on scrolling or tap on the tab.


![preview](https://github.com/bestiosdeveloper/PKCategoryView/blob/master/PKCategoryViewDemo/static.gif)


## Requirements

- iOS 11.0+
- Xcode 10.0+

## Installation

For manual instalation, drag Source folder into your project.

or use [CocoaPod](https://cocoapods.org) adding this line to you `Podfile`:

```ruby
pod 'PKCategoryView'
```

## Usage

#### For Static Tabs
It'll adjust all the tabs in the `PKCategoryView`'s width.

![preview](https://github.com/bestiosdeveloper/PKCategoryView/blob/master/PKCategoryViewDemo/static.gif)

Code example for setup:

```swift
//setting up the visual of the navBar
var config = PKCategoryViewConfiguration()
config.isNavBarScrollEnabled = false
config.normalColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1).withAlphaComponent(0.5)
config.selectedColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)
config.indicatorColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)

//frame for the category view
let rect = CGRect(x: 10.0, y: 60.0, width: (self.view.frame.size.width - 20.0), height: (self.view.frame.size.height - 70.0))

//setting up the tabs
let titleArr = ["Sushi", "Kebab", "Pizza", "Bread"]
let allTab = titleArr.map { PKCategoryItem(title: $0, normalImage: #imageLiteral(resourceName: "1"), selectedImage:#imageLiteral(resourceName: "2")) }

//create the child ViewControllers for the each tab
var allChild: [TabChildVC] = []
for (idx, ttl) in titleArr.enumerated() {
if let vc =  self.storyboard?.instantiateViewController(withIdentifier: "TabChildVC") as? TabChildVC {
vc.message = "Showing for \(ttl)"
vc.view.backgroundColor = (idx%2 == 0) ? UIColor.green.withAlphaComponent(0.3) : UIColor.yellow.withAlphaComponent(0.3)
allChild.append(vc)
}
}

//add category view to the viewController's desired view.
let catView = PKCategoryView(frame: rect, categories: allTab, childVCs: allChild, configuration: config, parentVC: self)
catView.delegate = self
self.view.addSubview(catView)
```


#### For Dynamic Tabs

It'll make the navBar as scrollable.

![preview](https://github.com/bestiosdeveloper/PKCategoryView/blob/master/PKCategoryViewDemo/dynamic.gif)

Code example for setup:

```swift
//setting up the visual of the navBar
var config = PKCategoryViewConfiguration()
config.isNavBarScrollEnabled = true
config.normalColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1).withAlphaComponent(0.5)
config.selectedColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)
config.indicatorColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)

//frame for the category view
let rect = CGRect(x: 10.0, y: 60.0, width: (self.view.frame.size.width - 20.0), height: (self.view.frame.size.height - 70.0))

//setting up the tabs
let titleArr = ["Pizza", "Sushi", "Bread", "Chocolate", "Massaman curry", "Buttered popcorn", "Hamburger", "Chicken", "Rendang", "Donuts"]
let allTab = titleArr.map { PKCategoryItem(title: $0, normalImage: #imageLiteral(resourceName: "1"), selectedImage:#imageLiteral(resourceName: "2")) }

//create the child ViewControllers for the each tab
var allChild: [TabChildVC] = []
for (idx, ttl) in titleArr.enumerated() {
if let vc =  self.storyboard?.instantiateViewController(withIdentifier: "TabChildVC") as? TabChildVC {
vc.message = "Showing for \(ttl)"
vc.view.backgroundColor = (idx%2 == 0) ? UIColor.green.withAlphaComponent(0.3) : UIColor.yellow.withAlphaComponent(0.3)
allChild.append(vc)
}
}

//add category view to the viewController's desired view.
let catView = PKCategoryView(frame: rect, categories: allTab, childVCs: allChild, configuration: config, parentVC: self)
catView.delegate = self
self.view.addSubview(catView)
```
#### Add Badge
For set the badge count at any index call the `setBadge` method of the categoryView.
Code example for setup:
```swift
catView.setBadge(count: 4, atIndex: 1)
```
Note: Badge can be set the the count or just a dot, refer the configuration properties for setting up the things

![preview](https://github.com/bestiosdeveloper/PKCategoryView/blob/master/PKCategoryViewDemo/Example_dot_count.png)

## Delegates

Just implement the protocol `PKCategoryViewDelegate` to the `UIViewController`'s class, after confirming the protocol there will be two methods:
1. `func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int)` will call before swtching the tabs.
2. `func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int)` will call just after the tab switched.

### Useful Property:
##### For NavBarView and ContentView:
There is a structur `PKCategoryViewConfiguration` used to provide the configuration for the category view. Some of usefull properties are:
1) `navBarHeight` used to give the height of the to navBar of category view. Default: `44.0`

2) `isNavBarScrollEnabled` used to decide navBar will be scrollable or not. Default: `false`

3) `defaultFont` used to provide the font for un-selected tabs.  Default: `UIFont.systemFont(ofSize: 15.0)`

4) `selectedFont` used to provide the font for selected tab.  Default: `UIFont.systemFont(ofSize: 17.0)`

5) `normalColor` used to provide the color for non-selected tabs.  Default: `#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)`

6) `selectedColor` used to provide the color for selected tab.  Default: `#colorLiteral(red: 0.9568627451, green: 0.6784313725, blue: 0.3843137255, alpha: 1)`

7) `showBottomSeparator` used to hide/show seprator between navBar and content view.  Default: `true`

8) `bottomSeparatorColor` used to provide the color for bottom seprator.  Default: `UIColor.lightGray`

9) `showIndicator` used to hide/show the indicator below the selected tab.  Default: `true`

10) `indicatorHeight` used to provide the height for the indicator view.  Default: `2.0`

11) `indicatorColor` used to provide the color for the indicator view.  Default: `#colorLiteral(red: 0.9568627451, green: 0.6784313725, blue: 0.3843137255, alpha: 1)`

##### For Badge:
1) `badgeBackgroundColor` used to provide background color for the badge view.  Default: `UIColor.red`
2) `badgeTextColor` used to provide text color for the badge view.  Default: `UIColor.white`
3) `shouldShowBadgeCount` used to decide, it will show as dot or badge count.  Default: `#colorLiteral(red: 0.9568627451, green: 0.6784313725, blue: 0.3843137255, alpha: 1)`

###### Usefull in case of dot:
4) `badgeDotSize` used to provide size for the badge view.  Default: `CGSize(width: 8.0, height: 8.0)`

###### Usefull in case of Badge Count:
5) `badgeTextFont` used to provide text font for the badge view.  Default: `UIFont.systemFont(ofSize: 12.0)`
6) `badgeInset` used to provide the padding for the badge content.  Default: `UIEdgeInsets(top: 1.0, left: 3.0, bottom: 1.0, right: 3.0)`
7) `maxBadgeCount` used to limit the badge count. If count exceed from maxBadgeCount, will be converted in to + format like: `99+`   Default: `99`
8) `badgeBorderWidth` used to provide border width for badge view.  Default: `0.0`
9) `badgeBorderColor` used to provide border color for badge view.  Default: `UIColor.clear`

## Licence

PKCategoryView is released under the MIT license.
