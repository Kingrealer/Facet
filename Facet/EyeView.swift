//
//  EyeView.swift
//  Facet
//
//  Created by LiuVV on 18/4/24.
//  Copyright © 2018年 liuvv. All rights reserved.
//

import UIKit

class EyeView: UIView {

    var _eyeOpen: Bool = false {
        didSet{
            setNeedsDisplay()
        }
    }
    var color: UIColor = UIColor.blue {
        didSet{
            setNeedsDisplay()
        }
    }

    var lineWidth: CGFloat = 5.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var eyeOpen: Bool{
        get{
            return _eyeOpen
        }
        set{
            if newValue != _eyeOpen {
                UIView.transition(with: self, duration: 2, options: .transitionFlipFromTop, animations: {self._eyeOpen = newValue})
            }
        }
    }

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let path: UIBezierPath
        
        if _eyeOpen {
            
            path = UIBezierPath(ovalIn: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2))
        }else{
            path = UIBezierPath()
            path.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
            
            path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        }
        
        
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    }
 

}
