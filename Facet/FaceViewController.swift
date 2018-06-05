//
//  ViewController.swift
//  Facet
//
//  Created by LiuVV on 18/4/3.
//  Copyright © 2018年 liuvv. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(faceView.changeScale(recognizer:))
            let pincnRecognizer = UIPinchGestureRecognizer(target: self.faceView, action: handler)
            
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.toggleEyes(recognizer:)))
//            tapRecognizer.numberOfTapsRequired = 1
            
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.increaseHappiness))
            swipeUpRecognizer.direction = .up
            
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.decreaseHappiness))
            swipeDownRecognizer.direction = .down
            
            
            faceView.addGestureRecognizer(pincnRecognizer)
            //faceView.addGestureRecognizer(tapRecognizer)
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }

    var expression = FacialExpression(eyes: .closed, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    private let mouthCulvatures: Dictionary<FacialExpression.Mouth, CGFloat> = [
        .frown : -1.0, .smirk : -0.5, .neutral: 0.0, .grin: 0.5, .smile: 1.0
    ]
    
    
    func increaseHappiness() {
        //print("increase")
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        //print("decrease")
        expression = expression.sadder
    }
    
//    func toggleEyes(recognizer: UITapGestureRecognizer){
//        switch recognizer.state {
//        case .ended:
//            let eyes: FacialExpression.Eyes = (expression.eyes == .open) ? .closed : .open
//            
//            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
//        default:
//            break
//        }
//    }
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()
    }
    
    private struct ShakeHead {
        static let angle = CGFloat.pi / 6.0
        static let segmentDuration: TimeInterval = 1.5
        
    }
    
    private func rotateFace(by angle: CGFloat){
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead(){
        UIView.animate(
            withDuration: ShakeHead.segmentDuration,
            animations: {self.rotateFace(by: -ShakeHead.angle)},
            completion: {finished in
                if finished {
                    UIView.animate(
                        withDuration: ShakeHead.segmentDuration,
                        animations: {self.rotateFace(by: ShakeHead.angle * 2)},
                        completion: {finished in
                            if finished {
                                UIView.animate(
                                    withDuration: ShakeHead.segmentDuration,
                                    animations: {self.rotateFace(by: -ShakeHead.angle)})
                            }
                            
                    })
                }
        })
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyeOpen = true
        case .closed:
            faceView?.eyeOpen = false
        case .squinting:
            faceView?.eyeOpen = false
        }
        
        faceView?.mouthCurvature = mouthCulvatures[expression.mouth] ?? 0
    }

}

