//
//  ShakingTextField.swift
//  Joblr
//
//  Created by Zhaoming Qin on 11/18/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import UIKit

class ShakingTextField: UITextField {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
}
