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
    let refreshTriggerHeight: CGFloat = 60
    
    // Accessible Properties
    var loadingHandler: (() -> Void)?
    var bgColor = UIColor.lightGray
    var loadingColor = UIColor.gray
    var spinningColor = UIColor.red
    
    private var progress: CGFloat = 0
    private var isLoading = false
    private var isTriggered = false
    
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
    
    private func commonInit() {
        addSubview(refreshView)
        addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    // MARK: - Interface
    
    func loadingComplete() {
        isLoading = false
        isScrollEnabled = true
        
        shapeLayer.removeAnimation(forKey: "rotateAnim")
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset", contentOffset.y < 0 else {
            return
        }
        
        let progress = abs(contentOffset.y) / refreshTriggerHeight
        
        if self.isDragging {
            if progress < 1.0 {
                updateRefreshProgress(progress)
            } else {
                isTriggered = true
                shapeLayer.strokeColor = spinningColor.cgColor
            }
        } else {
            if !isLoading && isTriggered {
                isLoading = true
                isTriggered = false
                isScrollEnabled = false
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    if let weakSelf = self {
                        weakSelf.contentInset = UIEdgeInsetsMake(weakSelf.contentInset.top + weakSelf.refreshHoldHeight, 0, 0, 0)
                    }
                }, completion: { [weak self] completion in
                    if let weakSelf = self {
                        weakSelf.spinningRefreshIndicator()
                        weakSelf.loadingHandler?()
                    }
                })
            }
        }
    }
    
    // MARK: - Internal
    
    private func initRefreshView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: -refreshHoldHeight, width: self.frame.size.width, height: refreshHoldHeight)
        view.backgroundColor = bgColor
        view.layer.addSublayer(shapeLayer)

        return view
    }
    
    private func initShapeLayer() -> CAShapeLayer {
        let radius: CGFloat = 15.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
        
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: (self.frame.width / 2) - radius, y: (refreshHoldHeight / 2) - radius, width: radius * 2, height: radius * 2)
        layer.path = circlePath.cgPath
        layer.fillColor = bgColor.cgColor
        layer.lineWidth = 3
        layer.strokeColor = loadingColor.cgColor
        layer.strokeStart = 0.0
        layer.strokeEnd = 0.0
        
        return layer
    }
    
    // MARK: - Internal - Graphics
    
    private func updateRefreshProgress(_ newProgress: CGFloat) {
        let layerAnim = CABasicAnimation(keyPath: "strokeEnd")
        layerAnim.fromValue = progress
        layerAnim.toValue = newProgress
        layerAnim.fillMode = kCAFillModeForwards
        layerAnim.isRemovedOnCompletion = false
        
        progress = newProgress
        
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.removeAnimation(forKey: "layerAnim")
        shapeLayer.add(layerAnim, forKey: "layerAnim")
    }
    
    private func spinningRefreshIndicator() {
        if shapeLayer.animation(forKey: "rotateAnim") == nil {
            let radius: CGFloat = 15.0
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 1.9), clockwise: true)
            
            let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnim.fromValue = 0
            rotateAnim.toValue = Double.pi * 2.0
            rotateAnim.duration = 1.0
            rotateAnim.repeatCount = Float.infinity
            
            shapeLayer.path = circlePath.cgPath
            shapeLayer.add(rotateAnim, forKey: "rotateAnim")
        }
    }
}
