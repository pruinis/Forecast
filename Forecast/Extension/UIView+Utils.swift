//
//  UIView+Utils.swift
//  Forecast
//
//  Created by Anton Morozov on 16.12.2019.
//  Copyright © 2019 Anton Morozov. All rights reserved.
//

import UIKit

extension UIView {    

    // MARK: - Shadow

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
   
    // MARK: - Blur

    func blurView(style: UIBlurEffect.Style) {
        removeBlur()
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(blurEffectView)
        
        UIView.animate(withDuration: 0.2) {
            blurEffectView.alpha = 0.5
        }
    }
    
    func removeBlur() {
        let blurViews = subviews.compactMap ({ $0 as? UIVisualEffectView })
        blurViews.forEach { (view) in view.removeFromSuperview() }
    }
}
