//
//  GameScene.swift
//  Lida2022
//
//  Created by Alexander Zimin on 12/09/2022.
//

import SpriteKit
import GameplayKit
import GameController
import AVFoundation

class GameScene: SKScene {
    
//    private var label : SKLabelNode?
    
    var playerXPoint: CGFloat = -100
//    var playerXPoint: CGFloat = 10000
    
    var virtualController: GCVirtualController?
    var friends: [AnotherPlayer] = []
    var jumpButton: SKNode?
    
    override func didMove(to view: SKView) {
        
//        enterLidalandShort()
        
        self.connectVirtualController()
        
        // self.playMusic()
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        var frame = self.frame
        frame.size.width += 10400
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
        
        self.alex = self.childNode(withName: "//Player_Alex") as? AnotherPlayer
        let ed = self.childNode(withName: "//Player_Ed") as? AnotherPlayer
        ed?.startEdAnimation()
        
        let names: [String] = Person.allCases.map({ $0.rawValue })
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
            case .showMickey:
                self.showMickey()
            case .enterLidaland:
                self.enterLidaland()
            case .showPostcard:
                self.showKirillPostcard()
            case .playHahaSound:
                let sound = SKAction.playSoundFileNamed("haha.mp3", waitForCompletion: false)
                self.run(sound)
            case .doMushroom:
                self.doMushroom()
            case .startHBSong:
                self.startHBSong()
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
    var alex: AnotherPlayer!
    
    func addPlayer() {
        let player = MainPlayer.create()
        player.position = CGPoint(x: self.playerXPoint, y: 100)
//        player.size = CGSize(width: 140, height: 140)
        player.zPosition = 12

        addChild(player)
        self.player = player
        
        self.camera?.position.x = player.position.x
    }
    
    func moveCharacter() {
        var isWalking = false
        
        for controller in self.activeControllers + [self.virtualController!.controller] {
            
            if controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 < -0.5 {
                player.position.x -= 3
                player.xScale = self.palayerScale
                isWalking = true
            } else if controller?.extendedGamepad?.leftThumbstick.xAxis.value ?? 0 > 0.5 {
                player.position.x += 3
                player.xScale = -self.palayerScale
                isWalking = true
            }
            
        }
        
        if isWalking {
            self.camera?.position.x = player.position.x
            player.walking(shouldWalk: true)
            
            if self.mushroomExists, let assets = self.mushroomAsset {
                if abs(assets.position.x - self.player.position.x) < 50 {
                    self.eatMushroom()
                }
            }
            
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
            
            if (controller.vendorName == "Gamepad" || (controller.vendorName ?? "").contains("Joy-Con")) {
                self.virtualController?.disconnect()
            }
            
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
            if !activeFriend.isActionBlocked {
                TalkController.shared.talkToSomeone(name: activeFriend.name ?? "")
            }
        }
    }
    
    var bgAnimation1: [SKTexture] = {
        var result: [SKTexture] = []
        for i in 0...30 {
            result.append(.init(imageNamed: "bg_start_anim_1_\(i)"))
        }
        return result
    }()
    
    var bgAnimation2: [SKTexture] = {
        var result: [SKTexture] = []
        for i in 0...30 {
            result.append(.init(imageNamed: "bg_start_anim_2_\(i)"))
        }
        return result
    }()
    
    var enterdLidaLand = false
    
    func enterLidalandShort() {
        TalkController.shared.enteredLidaLandFlag = true
        
        if let background = self.childNode(withName: "//Background_1") {
            background.removeFromParent()
        }
        
        if let wall = self.childNode(withName: "//First_Blocker") {
            wall.removeFromParent()
        }
        
        self.playMusic()
    }
    
    func enterLidaland() {
        TalkController.shared.enteredLidaLandFlag = true
        self.alex.isActionBlocked = true
        
        if let background = self.childNode(withName: "//Background_1") {
            background.run(SKAction.repeatForever(SKAction.animate(with: self.bgAnimation1, timePerFrame: 0.06)))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                background.removeAllActions()
                background.run(SKAction.repeatForever(SKAction.animate(with: self.bgAnimation2, timePerFrame: 0.06)))
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.playFirework()
                    self.playMusic()
                    
                    let duration: TimeInterval = 0.3
                    background.run(SKAction.fadeAlpha(to: 0, duration: duration))
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
                        self.alex.showMessage(text: "Добро пожаловать и проходи дальше")
                        background.removeFromParent()
                        if let wall = self.childNode(withName: "//First_Blocker") {
                            wall.removeFromParent()
                        }
                        self.alex.isActionBlocked = false
                    })
                })
            })
        }
    }
    
    func playFirework() {
        // create node that play textures
        let node = SKSpriteNode(imageNamed: "firework_0")
        node.zPosition = 15
        node.position = CGPoint(x: 730, y: 0)
        node.setScale(self.size.height / node.size.height)
        var frames: [SKTexture] = []
        for i in 0..<74 {
            frames.append(SKTexture(imageNamed: "firework_\(i)"))
        }
        self.addChild(node)
        node.run(SKAction.animate(with: frames, timePerFrame: 0.06)) {
            node.removeFromParent()
        }
    }
    
    func playFirework2() {
        // create node that play textures
        let node = SKSpriteNode(imageNamed: "firework_0")
        node.zPosition = 15
        node.position = CGPoint(x: 10560, y: 0)
        node.setScale(self.size.height / node.size.height)
        var frames: [SKTexture] = []
        for i in 0..<74 {
            frames.append(SKTexture(imageNamed: "firework_\(i)"))
        }
        self.addChild(node)
        node.run(SKAction.repeatForever(SKAction.animate(with: frames, timePerFrame: 0.04)))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12, execute: {
            node.removeFromParent()
        })
    }
    
    func playCoins() {
        // create node that play textures
        let node = SKSpriteNode(imageNamed: "coins_50")
        node.zPosition = 15
        node.position = CGPoint(x: 1857, y: 0)
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
    
    var mickeyNode: MickeyNode?
    
    func showMickey() {
        mickeyNode?.removeFromParent()
        
        let node = MickeyNode()
        let maxNodePosition = self.friends.first(where: { $0.name?.contains("Max") ?? false })?.position ?? .zero
        
        node.position = CGPoint(
            x: maxNodePosition.x + 300,
            y: maxNodePosition.y + 50
        )
        
        self.addChild(node)
        node.setScale(0)
        
        let scaleXAction = SKAction.scaleX(to: -1.0, duration: 2)
        let scaleYAction = SKAction.scaleY(to: 1.0, duration: 2)
        
        let topAction = SKAction.moveBy(x: 0, y: 100, duration: 1)
        topAction.timingMode = .easeOut
        let bottomAction = SKAction.moveBy(x: 0, y: -200, duration: 1)
        bottomAction.timingMode = .easeIn
        let moveAction = SKAction.sequence([topAction, bottomAction])
        
        node.run(moveAction)
        node.run(scaleXAction)
        node.run(scaleYAction)
        
        self.mickeyNode = node
    }
    
    var kirillPostcard: SKSpriteNode?
    
    func showKirillPostcard() {
        kirillPostcard?.removeFromParent()
        
        let node = SKSpriteNode(imageNamed: "Kirill_Postacard")
        node.zPosition = 10
        node.position = CGPoint(x: 2540, y: -200)
        node.setScale(0)
        self.addChild(node)
        
        let zoom = SKAction.scale(to: 1.15, duration: 0.8)
        zoom.timingMode = .easeIn
        
        let move = SKAction.moveTo(y: 200, duration: 0.8)
        move.timingMode = .easeIn
        
        node.run(zoom)
        node.run(move)
        
        self.kirillPostcard = node
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7, execute: {
            self.kirillPostcard?.removeFromParent()
        })
    }
    
    var mushroomAsset: SKSpriteNode?
    var mushroomExists: Bool = false
    
    var palayerScale: CGFloat = 0.5
    
    func eatMushroom() {
        self.mushroomAsset?.removeFromParent()
        self.mushroomExists = false
        self.palayerScale = 1
        
        let isNegative = player.xScale < 0
        
        let scaleX = SKAction.scaleX(to: isNegative ? -1 : 1, duration: 0.35)
        let scaleY = SKAction.scaleY(to: 1, duration: 0.35)
        
        self.player.run(scaleX)
        self.player.run(scaleY)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            self.palayerScale = 0.5
            let isNegative = self.player.xScale < 0
            
            let scaleX = SKAction.scaleX(to: isNegative ? -0.5 : 0.5, duration: 0.35)
            let scaleY = SKAction.scaleY(to: 0.5, duration: 0.35)
            
            self.player.run(scaleX)
            self.player.run(scaleY)
        })
    }
    
    func doMushroom() {
        self.mushroomAsset?.removeFromParent()
        self.mushroomExists = false
        
        let node = SKSpriteNode(imageNamed: "mushroom")
        node.zPosition = 10
        node.position = CGPoint(x: 3930, y: -200)
        node.setScale(0)
        self.addChild(node)
        
        let zoom = SKAction.scale(to: 0.65, duration: 0.8)
        zoom.timingMode = .easeIn
        
        let move = SKAction.moveTo(x: 4100, duration: 0.8)
        move.timingMode = .easeIn
        
        let moveY = SKAction.moveTo(y: -310, duration: 0.8)
        moveY.timingMode = .easeIn
        
        node.run(zoom)
        node.run(move)
        node.run(moveY)
        
        self.mushroomAsset = node
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.mushroomExists = true
        })
    }
    
    var isHPSongStarted = false
    
    func startHBSong() {
        if self.isHPSongStarted {
            return
        }
        self.isHPSongStarted = true
        
        self.playFirework2()
        
        self.musicPlayer?.stop()
        
        let sound = SKAction.playSoundFileNamed("hb_song.mp3", waitForCompletion: false)
        self.run(sound)
    }
    
    var musicPlayer: AVAudioPlayer?
    
    func playMusic() {
        let url = Bundle.main.url(forResource: "bg_song", withExtension: "mp3")
        
        do {
            self.musicPlayer = try AVAudioPlayer(contentsOf: url!)
            self.musicPlayer?.numberOfLoops = -1
            self.musicPlayer?.volume = 0.4
            self.musicPlayer?.currentTime = 3
            guard let musicPlayer = self.musicPlayer else { return }

            musicPlayer.prepareToPlay()
            musicPlayer.play()

        } catch let error as NSError {
            print(error.description)
        }
    }
}
