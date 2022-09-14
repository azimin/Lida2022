//
//  GameScene.swift
//  Lida2022
//
//  Created by Alexander Zimin on 12/09/2022.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
    
    var virtualController: GCVirtualController?
    var friends: [AnotherPlayer] = []
    var jumpButton: SKNode?
    
    override func didMove(to view: SKView) {
        
        self.connectVirtualController()
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        var frame = self.frame
        frame.size.width += 1000
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // Add camera node
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        // cameraNode update size
        cameraNode.setScale(1.22)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.addPlayer()
        
        let names: [String] = ["Player_Alex", "Player_Max"]
        for name in names {
            if let player = self.childNode(withName: "//" + name) as? AnotherPlayer {
                self.friends.append(player)
            }
        }
        
        if let button = self.childNode(withName: "//Button_Jump") {
            let scaleUpAction = SKAction.scale(by: 1.5, duration: 0.5)
            let scaleDownAction = SKAction.scale(by: 0.667, duration: 0.5)
            let action = SKAction.sequence([scaleUpAction, scaleDownAction])
            action.timingMode = .easeInEaseOut
            
            button.run(SKAction.repeatForever(action))
            
            self.jumpButton = button
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            if let player = self.childNode(withName: "//Player_Max") as? AnotherPlayer {
//                player.showMessage(text: "Hi there Hi there Hi there Hi there Hi there Hi there")
//            }
//        })
    }
    
    var activeFriend: AnotherPlayer?
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveCharacter()
        
        for friend in self.friends {
            var shouldRemoveAsset = false
            
            if abs(friend.position.y - self.player.position.y) > 140 {
                shouldRemoveAsset = true
            }
            
            if !shouldRemoveAsset && abs(friend.position.x - self.player.position.x) < 100 {
                friend.displayInteraction(isShowing: true)
                self.activeFriend = friend
            } else {
                shouldRemoveAsset = true
            }
            
            if shouldRemoveAsset {
                if self.activeFriend == friend {
                    self.activeFriend?.hideMessage()
                    self.activeFriend = nil
                }
                friend.displayInteraction(isShowing: false)
            }
        }
    }
    
    var player: MainPlayer!
    
    func addPlayer() {
        let player = MainPlayer.create()
        player.position = CGPoint(x: -100, y: 100)
//        player.size = CGSize(width: 140, height: 140)
        player.zPosition = 10

        addChild(player)
        self.player = player
        
        self.camera?.position.x = player.position.x
    }
    
    func moveCharacter() {
        var isWalking = false
        
        if virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 < -0.5 {
            player.position.x -= 3
            player.xScale = 0.5
            isWalking = true
        } else if virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 > 0.5 {
            player.position.x += 3
            player.xScale = -0.5
            isWalking = true
        }
        
        if isWalking {
            self.camera?.position.x = player.position.x
            player.walking(shouldWalk: true)
        } else {
            player.walking(shouldWalk: false)
        }
    }
    
    func connectVirtualController() {
        let virtualConfiguration = GCVirtualController.Configuration()
        
        virtualConfiguration.elements = [
            GCInputLeftThumbstick,
            GCInputButtonA,
            GCInputButtonB,
        ]

        let virtualController = GCVirtualController(configuration: virtualConfiguration)

        virtualController.connect()
        self.virtualController = virtualController
        
        virtualController.controller?.extendedGamepad?.buttonA.valueChangedHandler = { (button, value, pressed) in
            if pressed {
                self.activeFriend?.showMessage(text: "Hi there Hi there Hi there Hi there Hi there Hi there")
            }
        }

        virtualController.controller?.extendedGamepad?.buttonB.valueChangedHandler = { (button, value, pressed) in
            if pressed {
                // check if self.player is colliding with something
                self.jumpButton?.removeFromParent()
                if self.player.physicsBody?.allContactedBodies().first?.node != nil {
                    print("Jump")
                    self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 400))
                }
            }
        }
        
        virtualController.updateConfiguration(forElement: GCInputButtonB) { configuration in
            let jumpPath = UIBezierPath()
            jumpPath.move(to: CGPoint(x: -10, y: -10))
            jumpPath.addLine(to: CGPoint(x: -5, y: -5))
            jumpPath.addLine(to: CGPoint(x: 0, y: 5))
            jumpPath.addLine(to: CGPoint(x: 5, y: -5))
            jumpPath.addLine(to: CGPoint(x: -5, y: -5))
            configuration.path = jumpPath
            return configuration
        }
        
    }
}
