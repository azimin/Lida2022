//
//  TalkController.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation

class TalkController {
    static var shared = TalkController()
    
    enum Action {
        case message(message: String)
        case hideMessage
        case playCoins
    }
    
    var action: ((Action) -> Void)?
    
    var alexAction = 0
    
    func exitSomeone(name: String) {
        switch name {
        case "Player_Alex":
            self.alexAction = 0
        default:
            break
        }
    }
    
    func talkToSomeone(name: String) {
        switch name {
        case "Player_Alex":
            self.actionTalkWithAlex()
        default:
            break
        }
    }
    
    func actionTalkWithAlex() {
        switch alexAction {
        case 0:
            self.action?(.message(message: "Привет Лида, это ЛИДАЛЕНД!!!!!"))
        case 1:
            self.action?(.message(message: "Тут ты можешь найти поздравления и интерактив твоих друзей"))
        case 2:
            self.action?(.message(message: "А еще тут всякие пасхалки"))
        case 3:
            self.action?(.message(message: "Попробуй нажать 'A' еще раз, будет интерактив"))
        case 4:
            self.action?(.hideMessage)
            self.action?(.playCoins)
            alexAction = -1
        default:
            alexAction = -1
        }
        
        alexAction += 1
    }
}
