//
//  ViewController.swift
//  snake
//
//  Created by Steven Lee on 9/1/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var currentDirection: UISwipeGestureRecognizerDirection!
    var snake : [UIView]!
    var timer : Timer!
    var candy : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Gesture Setup
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        downSwipe.direction = .down
        upSwipe.direction = .up
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(downSwipe)
        
        // Set Current Direction
        self.currentDirection = .right
        
        let head = UIView(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 10, height: 10))
        head.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        head.backgroundColor = .green
        self.view.addSubview(head)
        
        self.snake = [head]
        
        // Timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(moveSnake), userInfo: nil, repeats: true)
        
        self.candy = UIView(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 10, height: 10))
        self.candy.backgroundColor = .red
        self.view.addSubview(candy)
        self.addCandy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Handle Swipe
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            print("Swipe Left")
            if (currentDirection != .right){
                currentDirection = .left
            }
        }
        
        if (sender.direction == .right) {
            print("Swipe Right")
            if (currentDirection != .left){
                currentDirection = .right
            }
        }
        
        if (sender.direction == .up) {
             print("Swipe Up")
             if (currentDirection != .down){
            currentDirection = .up
            }
        }
        
        if (sender.direction == .down) {
             print("Swipe Down")
             if (currentDirection != .up){
            currentDirection = .down
            }
        }
    }

    @objc func moveSnake() {
        var points : [CGPoint] = []
        updatePostion(self.snake.first!)
        for i in self.snake {
            points.append(i.center)
        }
    
        for i in 0...self.snake.count-1 {
            if (i-1 >= 0) {
                self.snake[i].center = points[i-1]
            }
        }
    }
    
    func updatePostion(_ view:UIView) {
        let xPos = view.center.x
        let yPos = view.center.y
        switch self.currentDirection {
        case .left:
            // Check If Candy
            tryToEat(view)
            // Check Edges
            if (xPos-10 < 0) {
                self.timer.invalidate()
            } else {
                view.center = CGPoint(x: xPos-10, y: yPos)
            }
            break
        case .right:
            // Check If Candy
            tryToEat(view)
            // Check Edges
            if (xPos+10 > self.view.frame.width) {
                self.timer.invalidate()
            } else {
                view.center = CGPoint(x: xPos+10, y: yPos)
            }
            break
        case .up:
            // try to eat
            tryToEat(view)
            // Check Edges
            if (yPos-10 < 0) {
                self.timer.invalidate()
            } else {
               view.center = CGPoint(x: xPos, y: yPos-10)
            }
            break
        case .down:
            // Try to eat
            tryToEat(view)
            // Check Edges
            if (yPos+10 > self.view.frame.height) {
                self.timer.invalidate()
            } else {
                view.center = CGPoint(x: xPos, y: yPos+10)
            }
        
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    func tryToEat(_ view:UIView) {
        if view.center == self.candy.center {
            addCandy()
            let link = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            link.backgroundColor = .black
            link.center = CGPoint(x: (self.snake.last?.center.x)!
                , y: (self.snake.last?.center.y)!)
            self.view.addSubview(link)
            
            self.snake.append(link)
            print("\(self.snake.count)")
            
        }
    }
    
    func addCandy() {
        self.candy.center = getRandomPoint()
    }
    
    func getRandomPoint() -> CGPoint {
        var randomNumX = CGFloat(arc4random_uniform(10) * 10)
        var randomNumY = CGFloat(arc4random_uniform(10) * 10)
        let coinFlipX = arc4random_uniform(2)
        let coinFlipY = arc4random_uniform(2)
        
        if (coinFlipX == 0) {
            randomNumX = -randomNumX
        }
        
        if (coinFlipY == 0) {
            randomNumY = -randomNumY
        }
        print("\(randomNumX) , \(randomNumY)")
        return CGPoint(x: self.view.frame.width/2 + randomNumX, y: self.view.frame.height/2 + randomNumY)
    }

}

