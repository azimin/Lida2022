//
//  ConfigOverride.swift
//  Lida2022
//
//  Created by Alexander Zimin on 15/09/2022.
//

import Foundation

struct Config {
    var scale: CGFloat?
    var yMove: Int?
    
    init(scale: CGFloat? = nil, yMove: Int? = nil) {
        self.scale = scale
        self.yMove = yMove
    }
}

class ConfigOverride {
    static var override: [String: Config] = [
        "Player_And_Rita": Config(scale: 0.6),
        "Player_Sasha": Config(scale: 0.4)
    ]
}
