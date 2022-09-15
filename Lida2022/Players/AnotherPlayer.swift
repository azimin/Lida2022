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
    
    var chatSide: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let playerName = self.name ?? ""
        var scale = (self.userData?.object(forKey: "scale") as? Float) ?? 1
        var yMove = (self.userData?.object(forKey: "yMove") as? Int) ?? 0
        self.chatSide = (self.userData?.object(forKey: "chatSide") as? Bool) ?? false
        
        if let override = ConfigOverride.override[playerName] {
            scale = Float(override.scale ?? CGFloat(scale))
            yMove = override.yMove ?? yMove
        }
        
        let player = SKSpriteNode(imageNamed: playerName)
        player.setScale(CGFloat(scale))
        player.position = CGPoint(x: player.position.x, y: player.position.y + CGFloat(yMove))
        self.size = player.frame.size
        self.addChild(player)
        
        self.interactionNode = SKSpriteNode(imageNamed: "Interaction_Badge")
        self.interactionNode.position = CGPoint(x: 0, y: self.frame.height - 15)
        self.addChild(self.interactionNode)
        
        let scaleUpAction = SKAction.scale(by: 1.5, duration: 0.5)
        let scaleDownAction = SKAction.scale(by: 0.66667, duration: 0.5)
        let action = SKAction.sequence([scaleUpAction, scaleDownAction])
        action.timingMode = .easeInEaseOut
        
        self.interactionNode.run(SKAction.repeatForever(action))
        self.interactionNode.isHidden = true
    }
    
    var isShowing: Bool = false
    var isMessageDisplayed: Bool = false
    var isActionBlocked = false {
        didSet {
            self.displayInteraction(isShowing: self.isShowing, force: true)
        }
    }
    
    func displayInteraction(isShowing: Bool, force: Bool = false) {
        var isShowing = isShowing
        
        if self.isMessageDisplayed {
            isShowing = false
        }
        
        if (self.isShowing != isShowing) {
            self.isShowing = isShowing
        }
        
        if self.isActionBlocked {
            isShowing = false
        }
        
        self.interactionNode.isHidden = !isShowing
    }
    
    func hideMessage() {
        self.messageNode?.removeFromParent()
        self.isMessageDisplayed = false
    }
    
    var isZoneEntered = false
    
    func showMessage(text: String) {
        self.hideMessage()
        
        self.isMessageDisplayed = true
        self.displayInteraction(isShowing: false)
        
        let messageNode = MessageNode(text: text, isSide: self.chatSide)
        self.addChild(messageNode)
        
        if self.chatSide {
            let move = (self.userData?.object(forKey: "chatSideMove") as? Int) ?? 0
            messageNode.position = CGPoint(x: self.frame.width + 40 + CGFloat(move), y: 0)
        } else {
            messageNode.position = CGPoint(x: -50, y: self.frame.height - 20)
        }
    
        self.messageNode = messageNode
        
        self.isZoneEntered = true
    }
}
