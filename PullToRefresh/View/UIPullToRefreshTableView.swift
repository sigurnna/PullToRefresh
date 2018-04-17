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
    let refreshTriggerHeight: CGFloat = 75
    
    var loadingHandler: (() -> Void)?
    
    private var progress: CGFloat = 0
    private var isLoading = false
    
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
    
    // MARK: - Interface
    
    func loadingComplete() {
        isLoading = false
        isScrollEnabled = true
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset", contentOffset.y < 0 else {
            return
        }
        
        let progress = abs(contentOffset.y) / refreshTriggerHeight
        
        if self.isDragging {
            updateRefreshProgress(progress)
        } else {
            if !isLoading && progress >= 1.0 {
                isLoading = true
                isScrollEnabled = false
                
                spinningRefreshIndicator()
                
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    if let weakSelf = self {
                        weakSelf.contentInset = UIEdgeInsetsMake(weakSelf.contentInset.top + weakSelf.refreshHoldHeight, 0, 0, 0)
                    }
                }, completion: { [weak self] completion in
                    self?.loadingHandler?()
                })
            }
        }
    }
    
    // MARK: - Internal - Init
    
    private func commonInit() {
        addSubview(refreshView)
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
        layer.lineWidth = 3
        layer.strokeColor = UIColor.red.cgColor
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
        
        shapeLayer.removeAllAnimations()
        shapeLayer.add(layerAnim, forKey: "layerAnim")
    }
    
    private func spinningRefreshIndicator() {
//        let layerAnim = CABasicAnimation(keyPath: "strokeEnd")
//        layerAnim.fromValue = 0.2
//        layerAnim.toValue = 1.1
//        layerAnim.fillMode = kCAFillModeForwards
//        layerAnim.isRemovedOnCompletion = false
//        
//        shapeLayer.removeAllAnimations()
//        shapeLayer.add(layerAnim, forKey: "layerAnim")
    }
}
