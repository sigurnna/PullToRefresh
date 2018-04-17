//
//  UIPullToRefreshTableView.swift
//  PullToRefresh
//
//  Created by 이승준 on 2018. 4. 17..
//  Copyright © 2018년 seungjun. All rights reserved.
//

import UIKit

class UIPullToRefreshTableView: UITableView {
    let refreshHoldHeight: CGFloat = 60
    
    private lazy var refreshView: UIView = {
        return initRefreshView()
    }()
    
    private lazy var shapeLayer: CAShapeLayer = {
        return initShapeLayer()
    }()
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else {
            return
        }
        
        NSLog("호엣")
    }
    
    // MARK: - Internal
    
    private func commonInit() {
        addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    private func initRefreshView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: -refreshHoldHeight, width: self.frame.size.width, height: refreshHoldHeight)
        view.backgroundColor = UIColor.lightGray
        view.layer.addSublayer(shapeLayer)

        return view
    }
    
    private func initShapeLayer() -> CAShapeLayer {
        let arcCenter = CGPoint(x: (self.frame.width / 2), y: (refreshHoldHeight / 2))
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: 15, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circlePath.cgPath
        layer.fillColor = UIColor.lightGray.cgColor
        layer.strokeColor = UIColor.red.cgColor
        layer.lineWidth = 3
        
        return layer
    }
}
