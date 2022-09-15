//
//  MickeyNode.swift
//  Lida2022
//
//  Created by Alexander Zimin on 15/09/2022.
//

import Foundation
import SpriteKit

class MickeyNode: SKSpriteNode {
    var frames: [SKTexture] = {
        var result: [SKTexture] = []
        for i in 0...13 {
            result.append(.init(imageNamed: "mickey_\(i)"))
        }
        return result
    }()
    
    convenience init() {
        self.init(imageNamed: "mickey_0")
        self.zPosition = 15
        self.run(SKAction.repeatForever(SKAction.animate(with: self.frames, timePerFrame: 0.06)))
    }
}
