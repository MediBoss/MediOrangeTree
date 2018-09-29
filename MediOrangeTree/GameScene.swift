//
//  GameScene.swift
//  MediOrangeTree
//
//  Created by Medi Assumani on 9/29/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    var orangeTree: SKSpriteNode!
    var orange: Orange?
    var touchStart:CGPoint = .zero
    var lazer = SKShapeNode()
    
    override func didMove(to view: SKView) {
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
        physicsWorld.contactDelegate = self
        
        lazer.lineWidth = 20
        lazer.lineCap = .round
        lazer.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(lazer)
    }
    
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // getting the location of the last touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // getting the difference from where the touch began and where it ended
        let dx = touchStart.x - location.x
        let dy = touchStart.y - location.y
        
        // making the orange fly
        let vector = CGVector(dx: dx, dy: dy)
        
        orange?.physicsBody?.isDynamic = true
        orange?.physicsBody?.applyImpulse(vector)
        
        //removing the lazer after the user finger has been removed
        lazer.path = nil
        
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
