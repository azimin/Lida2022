//
//  MessageNode.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation
import SpriteKit

class MessageNode: SKNode {
    var backgroundNode: SKSpriteNode!
    var interactionNode: SKSpriteNode!
    
    init(text: String, isSide: Bool) {
        super.init()
        
        let image = UIImage(named: isSide ? "Chat_Bubble_S" : "Chat_Bubble")!
        let texture = SKTexture(image: image)
        let node = SKSpriteNode(texture: texture)
        node.centerRect = CGRect(x: 0.5, y: 0.5, width: 0.1, height: 0.1)
        node.anchorPoint = .init(x: 0.5, y: 0)
        node.zPosition = 9
        self.backgroundNode = node
        self.addChild(node)
        
        let textNode = SKLabelNode(text: text)
        textNode.fontName = "Chalkduster"
        textNode.fontSize = 25
        textNode.numberOfLines = 0
        textNode.fontColor = .black
        textNode.preferredMaxLayoutWidth = 250
        textNode.zPosition = 10
        self.addChild(textNode)
        
        var textSize = textNode.frame.size
        textSize.width += 40
        textSize.height += 110
        self.backgroundNode.size = textSize
        self.backgroundNode.position = CGPoint(x: 0, y: -90)
        
        self.interactionNode = SKSpriteNode(imageNamed: "Interaction_Badge")
        self.interactionNode.position = CGPoint(x: 0, y: self.frame.height - 26)
        self.interactionNode.setScale(0.6)
        self.interactionNode.zPosition = 11
        self.addChild(self.interactionNode)
        
        let scaleUpAction = SKAction.scale(by: 0.6, duration: 1)
        let scaleDownAction = SKAction.scale(by: 1.6667, duration: 1)
        let action = SKAction.sequence([scaleUpAction, scaleDownAction])
        action.timingMode = .easeInEaseOut
        
        self.interactionNode.run(SKAction.repeatForever(action))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
