//
//  FaceView.swift
//  Facet
//
//  Created by LiuVV on 18/4/3.
//  Copyright © 2018年 liuvv. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet{setNeedsDisplay()} }
    
    @IBInspectable
    var eyeOpen: Bool = false {
        didSet{
            //setNeedsDisplay()
            leftEye.eyeOpen = eyeOpen
            rightEye.eyeOpen = eyeOpen
        }
    }
    
    @IBInspectable
    var mouthCurvature: CGFloat = 1.0 { didSet{setNeedsDisplay()} }     //-1 sadest, 1 happpiest
    
    @IBInspectable
    var color: UIColor = UIColor.green {
        didSet{
            setNeedsDisplay()
            leftEye.color = color
            rightEye.color = color
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet{
            setNeedsDisplay()
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
        }
    }
    
    private var skullCenter: CGPoint{   //相当于常量
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    // Handler
    func changeScale(recognizer: UIPinchGestureRecognizer){
        switch recognizer.state {
        case .began, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1
        default:
            break
        }
    }
    
    
    
    private func pathForSkull()->UIBezierPath{
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    private enum Eye {
        case left
        case right
    }
    
    private func centerOfEye(_ eye: Eye)->CGPoint{
        let eyeOffset = skullRadius / Radius.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        eyeCenter.x += (eye == Eye.left) ? -eyeOffset : eyeOffset
        
        return eyeCenter
    }
    
//    private func pathForEye(_ eye: Eye)->UIBezierPath{
//        
//        
//        
//        let eyeRadius = skullRadius / Radius.SkullRadiusToEyeRadius
//        
//        let eyeCenter = centerOfEye(eye)
//        
//        let path: UIBezierPath
//        
//        if eyeOpen {
//            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
//        }else{
//            path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            
//            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//        }
//        
//        
//        path.lineWidth = lineWidth
//        
//        return path
//    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye()->EyeView{
        let eyeView = EyeView()
        eyeView.isOpaque = false
        eyeView.color = color
        eyeView.lineWidth = lineWidth
        eyeView.eyeOpen = eyeOpen
        addSubview(eyeView)
        return eyeView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(eyeView: leftEye, center: centerOfEye(.left))
        positionEye(eyeView: rightEye, center: centerOfEye(.right))
    }
    
    private func positionEye(eyeView: EyeView, center: CGPoint){
        let size = skullRadius / Radius.SkullRadiusToEyeRadius * 2
        eyeView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eyeView.center = center
    }
    
    
    
    private func pathForMouth()->UIBezierPath{
        let mouthOffset = skullRadius / Radius.SkullRadiusToMouthOffset
        let mouthWidth = skullRadius / Radius.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Radius.SkullRadiusToMouthHeight
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = mouthHeight * min(1, max(-1, mouthCurvature))
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileOffset)
        
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: start.y + smileOffset)
        
        //let path = UIBezierPath(rect: mouthRect)
        
        let path = UIBezierPath()
        
        path.move(to: start)
        
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        
        path.lineWidth = lineWidth
        
        return path
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        color.set()
        
        pathForSkull().stroke()
        //pathForEye(.left).stroke()
        //pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    private struct Radius{
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
    }
    
    
}
