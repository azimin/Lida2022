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
    
    var playerXPoint: CGFloat = 1000
    
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
        frame.size.width += 3000
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = 0b0111

        // Add camera node
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        // cameraNode update size
        cameraNode.setScale(1.22)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        self.addPlayer()
        
        let names: [String] = ["Player_Alex", "Player_Max", "Player_Shura"]
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
        
        TalkController.shared.action = { action in
            switch action {
            case .message(let message):
                self.activeFriend?.showMessage(text: message)
            case .hideMessage:
                self.activeFriend?.hideMessage()
            case .playCoins:
                self.playCoins()
            }
        }
    }
    
    var activeFriend: AnotherPlayer?
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveCharacter()
        
        
        if (self.player.physicsBody?.velocity.dy ?? 0) < -200 {
            self.player.physicsBody?.collisionBitMask = 2
        } else if (self.player.physicsBody?.velocity.dy ?? 0) > 200 {
            self.player.physicsBody?.collisionBitMask = 1
        }
        
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
                    self.activeFriend?.isZoneEntered = false
                    TalkController.shared.exitSomeone(name: self.activeFriend?.name ?? "")
                    self.activeFriend = nil
                }
                friend.displayInteraction(isShowing: false)
            }
        }
    }
    
    var player: MainPlayer!
    
    func addPlayer() {
        let player = MainPlayer.create()
        player.position = CGPoint(x: self.playerXPoint, y: 100)
//        player.size = CGSize(width: 140, height: 140)
        player.zPosition = 10

        addChild(player)
        self.player = player
        
        self.camera?.position.x = player.position.x
    }
    
    func moveCharacter() {
        var isWalking = false
        
        for controller in self.activeControllers + [self.virtualController!.controller] {
            
            if controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 < -0.5 {
                player.position.x -= 3
                player.xScale = 0.5
                isWalking = true
            } else if controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 > 0.5 {
                player.position.x += 3
                player.xScale = -0.5
                isWalking = true
            }
            
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
                self.pressAButton()
            }
        }

        virtualController.controller?.extendedGamepad?.buttonB.valueChangedHandler = { (button, value, pressed) in
            if pressed {
                // check if self.player is colliding with something
                self.pressBButton()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectControllers), name: NSNotification.Name.GCControllerDidConnect, object: nil)
    }
    
    var activeControllers: [GCController] = []
    
    @objc func connectControllers() {
        for controller in GCController.controllers() {
            activeControllers.append(controller)
            
            self.virtualController?.disconnect()
            
            controller.extendedGamepad?.buttonB.valueChangedHandler = { (button, value, pressed) in
                if pressed {
                    // check if self.player is colliding with something
                    self.pressBButton()
                }
            }
            
            controller.extendedGamepad?.buttonA.valueChangedHandler = { (button, value, pressed) in
                if pressed {
                    // check if self.player is colliding with something
                    self.pressAButton()
                }
            }
        }
    }
    
    func pressBButton() {
        self.jumpButton?.removeFromParent()
        if self.player.physicsBody?.allContactedBodies().first?.node != nil {
            self.player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 450))
        }
    }
    
    func pressAButton() {
        if let activeFriend = self.activeFriend {
            TalkController.shared.talkToSomeone(name: activeFriend.name ?? "")
        }
    }
    
    func playCoins() {
        // create node that play textures
        let node = SKSpriteNode(imageNamed: "coins_50")
        node.zPosition = 15
        node.position = CGPoint(x: 400, y: 0)
        node.setScale(self.size.height / node.size.height)
        var frames: [SKTexture] = []
        for i in 1..<105 {
            frames.append(SKTexture(imageNamed: "coins_\(i)"))
        }
        self.addChild(node)
        node.run(SKAction.animate(with: frames, timePerFrame: 0.03)) {
            node.removeFromParent()
        }
    }
    
    
}
