//
//  Orange.swift
//  MediOrangeTree
//
//  Created by Medi Assumani on 9/29/18.
//  Copyright © 2018 Medi Assumani. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Orange: SKSpriteNode{
    
    init(){
        let texture = SKTexture(imageNamed: "Orange")
        let size = texture.size()
        let color = UIColor.clear
        
        super.init(texture: texture, color: color, size: size)
        physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
}
