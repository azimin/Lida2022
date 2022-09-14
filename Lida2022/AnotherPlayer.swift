//
//  AnotherPlayer.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation
import SpriteKit

class AnotherPlayer: SKSpriteNode {
    var messageNode: MessageNode?
    var interactionNode: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let playerName = (self.userData?.object(forKey: "name") as? String) ?? ""
        let scale = (self.userData?.object(forKey: "scale") as? Float) ?? 1
        
        let player = SKSpriteNode(imageNamed: playerName)
        player.setScale(CGFloat(scale))
        self.size = player.frame.size
        self.addChild(player)
        
        self.interactionNode = SKSpriteNode(imageNamed: "Interaction_Badge")
        self.interactionNode.position = CGPoint(x: 0, y: self.frame.height - 15)
        self.addChild(self.interactionNode)
        
        let scaleUpAction = SKAction.scale(by: 1.5, duration: 0.5)
        let scaleDownAction = SKAction.scale(by: 0.667, duration: 0.5)
        let action = SKAction.sequence([scaleUpAction, scaleDownAction])
        action.timingMode = .easeInEaseOut
        
        self.interactionNode.run(SKAction.repeatForever(action))
        self.interactionNode.isHidden = true
    }
    
    var isShowing: Bool = false
    var isMessageDisplayed: Bool = false
    
    func displayInteraction(isShowing: Bool) {
        var isShowing = isShowing
        
        if self.isMessageDisplayed {
            isShowing = false
        }
        
        if (self.isShowing != isShowing) {
            self.isShowing = isShowing
        }
        
        self.interactionNode.isHidden = !isShowing
    }
    
    func hideMessage() {
        self.messageNode?.removeFromParent()
        self.isMessageDisplayed = false
    }
    
    func showMessage(text: String) {
        self.hideMessage()
        
        self.isMessageDisplayed = true
        self.displayInteraction(isShowing: false)
        
        let messageNode = MessageNode(text: text)
        self.addChild(messageNode)
        print(self.frame)
        messageNode.position = CGPoint(x: -50, y: self.frame.height - 20)
        self.messageNode = messageNode
    }
}
