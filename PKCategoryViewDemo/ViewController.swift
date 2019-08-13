//
//  ViewController.swift
//
//  Created by Pramod Kumar on 08/08/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var config = PKCategoryViewConfiguration()
        config.isNavBarScrollEnabled = false
        config.normalColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1).withAlphaComponent(0.5)
        config.selectedColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)
        config.indicatorColor = #colorLiteral(red: 0, green: 0.8, blue: 0.6, alpha: 1)
        
        let rect = CGRect(x: 10.0, y: 60.0, width: (self.view.frame.size.width - 20.0), height: (self.view.frame.size.height - 70.0))
        
//        let titleArr = ["Pizza", "Sushi", "Bread", "Chocolate", "Massaman curry", "Buttered popcorn", "Hamburger", "Chicken", "Rendang", "Donuts"]
        
        let titleArr = ["Sushi", "Kebab", "Pizza", "Bread"]
        let allTab = titleArr.map { PKCategoryItem(title: $0, normalImage: #imageLiteral(resourceName: "1"), selectedImage:#imageLiteral(resourceName: "2")) }
        
        var allChild: [TabChildVC] = []
        for (idx, ttl) in titleArr.enumerated() {
            if let vc =  self.storyboard?.instantiateViewController(withIdentifier: "TabChildVC") as? TabChildVC {
                vc.message = "Showing for \(ttl)"
                vc.view.backgroundColor = (idx%2 == 0) ? UIColor.green.withAlphaComponent(0.3) : UIColor.yellow.withAlphaComponent(0.3)
                allChild.append(vc)
            }
        }
        
        let catView = PKCategoryView(frame: rect, categories: allTab, childVCs: allChild, configuration: config, parentVC: self)
        catView.delegate = self

        self.view.addSubview(catView)
        
        self.addEdgeSwipeGesture()
    }

    private func addEdgeSwipeGesture() {
        let openGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeSwipeAction(_:)))
        openGesture.edges = .left
        
        self.view.addGestureRecognizer(openGesture)
    }
    
    @objc private func edgeSwipeAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            print("edge swiped")
        }
    }
}

extension ViewController: PKCategoryViewDelegate {
    func categoryView(_ view: PKCategoryView, willSwitchIndexFrom fromIndex: Int, to toIndex: Int) {
        print("willSwitchIndexFrom \(fromIndex) to \(toIndex)")
    }
    
    func categoryView(_ view: PKCategoryView, didSwitchIndexTo toIndex: Int) {
        print("didSwitchIndexTo \(toIndex)")
    }
}

