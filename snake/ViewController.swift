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
        
        self.view.backgroundColor = .black
        
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
        self.currentDirection = .up
        
        self.startGame()
        
        self.candy = UIView(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 10, height: 10))
        self.candy.backgroundColor = .red
        self.candy.layer.cornerRadius = 5;
        self.candy.layer.masksToBounds = true;
        self.view.addSubview(candy)
        self.moveCandy()
    }

    // Handle Swipe
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if (currentDirection != .right){
                currentDirection = .left
            }
        }
        
        if (sender.direction == .right) {
            if (currentDirection != .left){
                currentDirection = .right
            }
        }
        
        if (sender.direction == .up) {
             if (currentDirection != .down){
            currentDirection = .up
            }
        }
        
        if (sender.direction == .down) {
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
            // Check Edges
            if (xPos-10 < 0) {
                self.endGame()
            } else {
                view.center = CGPoint(x: xPos-10, y: yPos)
                tryToEat(view)
            }
            break
        case .right:
            // Check Edges
            if (xPos+10 > self.view.frame.width) {
                self.endGame()
            } else {
                view.center = CGPoint(x: xPos+10, y: yPos)
                tryToEat(view)
            }
            break
        case .up:
            // Check Edges
            if (yPos-10 < 0) {
                self.endGame()
            } else {
               view.center = CGPoint(x: xPos, y: yPos-10)
                tryToEat(view)
            }
            break
        case .down:
            // Check Edges
            if (yPos+10 > self.view.frame.height) {
                self.endGame()
            } else {
                view.center = CGPoint(x: xPos, y: yPos+10)
                tryToEat(view)
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
            self.moveCandy()
            let link = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            link.backgroundColor = .green
            link.center = CGPoint(x: (self.snake.last?.center.x)!
                , y: (self.snake.last?.center.y)!)
            link.layer.cornerRadius = 5;
            link.layer.masksToBounds = true;
            self.view.addSubview(link)
            self.snake.append(link)
        }
        
        var cnt = 0
        for i in self.snake {
            if i.center == self.snake.first?.center {
                cnt += 1
                if (cnt > 2 && self.snake.count > 3) {
                    self.endGame()
                    //self.snake.removeLast(self.snake.count - self.snake.index(of: i)!)
                    break
                }
            }
        }
      
    }
    
    func moveCandy() {
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
        return CGPoint(x: self.view.frame.width/2 + randomNumX, y: self.view.frame.height/2 + randomNumY)
    }
    
    func startGame() {
        if (snake != nil){
            for i in snake {
                i.removeFromSuperview()
            }
        }
        let head = UIView(frame: CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 10, height: 10))
        head.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        head.backgroundColor = .green
        head.layer.cornerRadius = 5;
        head.layer.masksToBounds = true;
        self.view.addSubview(head)
        
        self.snake = [head]
        
        // Timer
        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(moveSnake), userInfo: nil, repeats: true)
        
        
    }
    
    func endGame() {
        self.timer.invalidate()
        let highScore = UserDefaults.standard.integer(forKey: "score")
        if (highScore < self.snake.count) {
            UserDefaults.standard.set(self.snake.count, forKey: "score")
        }
        let alert = UIAlertController(title: "Score: \(self.snake.count)", message: "Nice Job! High Score: \(UserDefaults.standard.integer(forKey: "score"))", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: { (action) in
            self.startGame()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

