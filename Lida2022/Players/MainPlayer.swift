//
//  MainPlayer.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation
import SpriteKit

class MainPlayer: SKSpriteNode {
    var innerNode = SKSpriteNode(imageNamed: "out (0)")
    
    var frames: [SKTexture] = [
        .init(imageNamed: "out (0)"),
        .init(imageNamed: "out (1)"),
        .init(imageNamed: "out (2)"),
        .init(imageNamed: "out (3)"),
        .init(imageNamed: "out (4)"),
        .init(imageNamed: "out (5)"),
        .init(imageNamed: "out (6)"),
        .init(imageNamed: "out (7)"),
        .init(imageNamed: "out (8)"),
        .init(imageNamed: "out (9)"),
        .init(imageNamed: "out (10)"),
        .init(imageNamed: "out (11)"),
        .init(imageNamed: "out (12)")
    ]
    
    static func create() -> MainPlayer {
        let node = MainPlayer()
        
        node.setScale(0.5)
        node.addChild(node.innerNode)
        node.size = CGSize(width: node.innerNode.size.width / 2, height: node.innerNode.size.height / 2)
        
        var physicsSize = node.frame.size
        physicsSize.width = physicsSize.width / 2
        
        node.physicsBody = SKPhysicsBody(rectangleOf: physicsSize, center: CGPoint(x: 0, y: 0))
        node.physicsBody?.isDynamic = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.mass = 0.5
        
        return node
    }
    
    var isWalking = false
    
    func walking(shouldWalk: Bool) {
        if shouldWalk != self.isWalking {
            self.isWalking = shouldWalk
        } else {
            return
        }
        
        if (shouldWalk) {
            self.innerNode.run(SKAction.repeatForever(SKAction.animate(with: self.frames, timePerFrame: 0.1)))
        } else {
            self.innerNode.removeAllActions()
        }
    }
}
