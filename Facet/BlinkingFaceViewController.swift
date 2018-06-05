//
//  BlinkingFaceViewController.swift
//  Facet
//
//  Created by LiuVV on 18/4/17.
//  Copyright © 2018年 liuvv. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking:Bool = false {
        didSet{
            blinkIfNeeded()
        }
    }
    
    struct BlinkRate {
        static let closeDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blinking = true
    }
    
    private func blinkIfNeeded(){
        faceView.eyeOpen = false
        Timer.scheduledTimer(withTimeInterval: BlinkRate.closeDuration, repeats: false){[weak self]timer in
            self?.faceView.eyeOpen = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false){[weak self]timer in
            self?.blinkIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        blinking = false
    }
}
