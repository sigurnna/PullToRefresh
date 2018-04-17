//
//  PullToRefreshView.swift
//  PullToRefresh
//
//  Created by 이승준 on 2018. 4. 17..
//  Copyright © 2018년 seungjun. All rights reserved.
//

import UIKit

let refreshViewTag = 0
let refreshHoldHeight: CGFloat = 60

extension UITableView {

    func addPullToRefresh(completion: () -> Void) {
        addRefreshView()
    }
}

fileprivate extension UITableView {
    
    func addRefreshView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: -refreshHoldHeight, width: self.frame.size.width, height: refreshHoldHeight)
        view.backgroundColor = UIColor.gray
        view.tag = refreshViewTag
        
        let arcCenter = CGPoint(x: (self.frame.width / 2), y: (refreshHoldHeight / 2))
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: 20, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor

        view.layer.addSublayer(shapeLayer)
        addSubview(view)
    }
    
    func refreshView() -> UIView? {
        return self.viewWithTag(refreshViewTag)
    }
}
