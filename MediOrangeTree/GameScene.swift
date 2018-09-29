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
    
    override func didMove(to view: SKView) {
        orangeTree = childNode(withName: "tree") as! SKSpriteNode
        physicsWorld.contactDelegate = self
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
