//
//  EmotionaViewController.swift
//  Facet
//
//  Created by LiuVV on 18/4/17.
//  Copyright © 2018年 liuvv. All rights reserved.
//

import UIKit

class EmotionViewController: UITableViewController {

    let emotionFace:[(name:String, expression: FacialExpression)]=[
        ("happy" , FacialExpression(eyes: .open,mouth: .smile)),
        ("sad" , FacialExpression(eyes: .closed,mouth: .frown)),
        ("worried" , FacialExpression(eyes: .closed,mouth: .neutral))
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionFace.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
        cell.textLabel?.text = emotionFace[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        
        if let navigator = destinationViewController as? UINavigationController{
            destinationViewController = navigator.visibleViewController ?? destinationViewController
        }
        
        if let faceViewController = destinationViewController as? FaceViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell){
            faceViewController.expression = emotionFace[indexPath.row].expression
            faceViewController.navigationItem.title = emotionFace[indexPath.row].name
        }
    }
}
