//
//  GameScene.swift
//  MediOrangeTree
//
//  Created by Medi Assumani on 9/29/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import SpriteKit
import UIKit
import Foundation

class GameScene: SKScene {
    
    // Needed class properties
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart:CGPoint = .zero
    var lazer = SKShapeNode()
    var boundary = SKNode()
    let numOfLevels: UInt32 = 2
    
    // Function to check if the scene has moved
    override func didMove(to view: SKView) {
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
        physicsWorld.contactDelegate = self
        
        // making sure the oranges stay within the screen boundary
        boundary.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(origin: .zero, size: size))
        boundary.position = .zero
        addChild(boundary)
        
        lazer.lineWidth = 20
        lazer.lineCap = .round
        lazer.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(lazer)
        
        
        // Adding the sun to the scene
        let sun = SKSpriteNode(imageNamed: "Sun")
        sun.name = "sun"
        sun.position.x = size.width - (sun.size.width * 0.75)
        sun.position.y = size.height - (sun.size.height * 0.75)
        addChild(sun)
    }
    
    // function to check if the user has touched the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        if atPoint(location).name == "tree" {
            orange = Orange()
            orange?.physicsBody?.isDynamic = false
            orange?.position = location
            addChild(orange!)
            
            //storing the location of the touch
            touchStart = location
        }
        
        
        // changing the level by taping the sun
        nodes(at: location).forEach { (node) in
            if node.name == "sun" {
                let randomLevel = Int(arc4random() % numOfLevels + 1)
                if let scene = GameScene.load(level: randomLevel){
                    scene.scaleMode = .aspectFill
                    if let view = view {
                        view.presentScene(scene)
                    }
                }
            }
        }
    }
    
    //This function is called when a touch is dragged across the screen by a user's finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let location = touch.location(in: self)
        
        orange?.position = location
        
        //Drawing the vector
        let path =  UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        lazer.path = path.cgPath
    }
    
    
    // function to check if the user stoped touching the screen
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // getting the location of the last touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // getting the difference from where the touch began and where it ended
        let dx = (touchStart.x - location.x) * 0.5
        let dy = (touchStart.y - location.y) * 0.5
        
        // making the orange fly
        let vector = CGVector(dx: dx, dy: dy)
        
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        
        //removing the lazer after the user finger has been removed
        lazer.path = nil
        
    }
    
    // Class method to load .sks files
    static func load(level: Int) -> GameScene? {
        return GameScene(fileNamed: "Level-\(level)")
    }
}

extension GameScene: SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if contact.collisionImpulse > 15 {
            if nodeA?.name == "skull"{
                removeSkull(object: nodeA!)
            }else if nodeB?.name == "skull"{
                removeSkull(object: nodeB!)
            }
        }
    }
    
    func removeSkull(object: SKNode){
        object.removeFromParent()
    }
}
