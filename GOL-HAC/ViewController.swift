//
//  ViewController.swift
//  GOL-HAC
//
//  Created by Héctor Cuevas Morfín on 11/14/16.
//  Copyright © 2016 HACM. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    @IBOutlet weak var labelPoblation: UILabel!

    @IBOutlet weak var lifeCanvas : LifeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        lifeCanvas.delegate = self
    }
    @IBAction func pushStartButton(_ sender : AnyObject) {
        
        lifeCanvas.changeWorldStatus()
        
        if lifeCanvas.isRunning {
            sender.setTitle("Detener", for: .normal)
        } else {
            sender.setTitle("Continuar", for: .normal)
        }
        
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent!) {
        if motion == .motionShake {
            lifeCanvas.seedWorld()
        }
    }

}

extension ViewController: LifeViewDelegate{
    func poblationChanged(with poblation: Int) {
        labelPoblation.text = "Population: \(poblation)"
    }
}
