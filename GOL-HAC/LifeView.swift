//
//  LifeView.swift
//  GOL-HAC
//
//  Created by Héctor Cuevas Morfín on 11/17/16.
//  Copyright © 2016 HACM. All rights reserved.
//

import UIKit
import QuartzCore

protocol LifeViewDelegate {
    func poblationChanged(with poblation:Int)
}

class LifeView: UIView {
    var delegate:LifeViewDelegate!
    //the height of the view minus the button section
    let (worldW, worldH) = (Int(UIScreen.main.bounds.width), Int(UIScreen.main.bounds.height)-64)
    
    let cellSize:CGFloat = 1.0
    
    //Arrays to store the current world
    var currentWorld: [Int8]
    
    //Time related data
    var isRunning: Bool
    var ticker: Timer
    
    
    required  init(coder aDecoder: NSCoder)  {
        
        //Initialize world arrays
        currentWorld = [Int8](repeating: 0, count: worldW * worldH)
        
        //The world is stoped
        isRunning = false
        ticker = Timer()
        
        //Initialize the view
        super.init(coder: aDecoder)!
        
        //Fill current world with random data
        seedWorld()
        
    }
    
    
    
    //world with life random
    func seedWorld() {
        for f in 0..<worldW * worldH {
            currentWorld[f] = Int8(arc4random()%2)
        }
        self.setNeedsDisplay()
    }
    
    
    func changeWorldStatus() {
        
        isRunning = !isRunning
        
        if isRunning {
            ticker = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(LifeView.generation), userInfo: nil, repeats: true)
        } else {
            ticker.invalidate()
            
        }
    }
    
    
    
    //Function to calculate the amount of alive neighbours one cell has
    //No optimization going on here
    func neighbourCellState (_ x: Int, y:Int) -> Int8 {
        
        var adjustedX: Int, adjustedY: Int
        
        switch x {
        case -1: adjustedX = worldW  - 1
        case worldW : adjustedX = 0
        default: adjustedX = x
        }
        
        switch y {
        case -1: adjustedY = worldH  - 1
        case worldH : adjustedY = 0
        default: adjustedY = y
        }
        
        return currentWorld[adjustedX + adjustedY * worldW]
    }
    

    //Calculate next generation to show
    func generation() {
        
        var futureWorld = [Int8](repeating: 0, count: worldW * worldH)
        
        var index = 0
        var numberOfLifes = 0
        for y in 0..<worldH {
            
            for x in 0..<worldW {
                
                let neighbours = neighbourCellState(x-1,y:y-1) +
                    neighbourCellState(x,y:y-1) +
                    neighbourCellState(x+1,y:y-1) +
                    neighbourCellState(x-1,y:y) +
                    neighbourCellState(x+1,y:y) +
                    neighbourCellState(x-1,y:y+1) +
                    neighbourCellState(x,y:y+1) +
                    neighbourCellState(x+1,y:y+1)
                
                if neighbours == 2 {
                    futureWorld[index] = currentWorld[index]
                } else if neighbours == 3 {
                    futureWorld[index] = 1
                    numberOfLifes += 1
                }else{
                   numberOfLifes += Int(neighbourCellState(x, y: y))
                }
                
                index += 1
            }
        }
        delegate.poblationChanged(with: numberOfLifes)
        currentWorld = futureWorld
        self.setNeedsDisplay()
        
    }
    
    
    
    //Repaints the world view
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext();
        //red because I like the red color 
        context?.setFillColor(UIColor.red.cgColor)
        for y in 0..<worldH {
            
            for x in 0..<worldW {
                
                if currentWorld[x + y * worldW]==1 {
                    let rectangle = CGRect(x: cellSize*CGFloat(x),y: cellSize*CGFloat(y), width: cellSize, height: cellSize)
                    context?.fill(rectangle);
                    
                }
                
            }
            
        }
        
    }
    
}
