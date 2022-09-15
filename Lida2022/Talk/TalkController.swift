//
//  TalkController.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation

enum Person: String {
    case alex = "Player_Alex"
    case max = "Player_Max"
    case shura = "Player_Shura"
}

class TalkController {
    static var shared = TalkController()
    
    enum Action {
        case message(message: String)
        case hideMessage
        case playCoins
        case showMickey
    }
    
    var action: ((Action) -> Void)?
    
    var personActions: [String: Int] = [:]
    
    var alexAction = 0
    var maxAction = 0
    
    func exitSomeone(name: String) {
        self.personActions[name] = 0
    }
    
    func talkToSomeone(name: String) {
        self.applyPersonActions(name: name)
    }
    
    func increaseCounter(name: String) {
        self.personActions[name] = (self.personActions[name] ?? 0) + 1
    }

    func applyPersonActions(name: String) {
        let person = Person(rawValue: name)
        let actions: [[Action]]
        
        switch person {
        case .alex:
            actions = alexActions()
        case .max:
            actions = maxActions()
        case .shura:
            actions = shuraActions()
        default:
            actions = [[]]
            assertionFailure("No person")
        }
        
        var number = self.personActions[name] ?? 0
        if number >= actions.count {
            self.personActions[name] = 0
            number = 0
        }
        
        let currentActions = actions[number]
        for action in currentActions {
            self.action?(action)
        }
        
        self.increaseCounter(name: name)
    }
    
    func alexActions() -> [[Action]] {
        return [
            [.message(message: "Привет Лида, это ЛИДАЛЕНД!!!!!")],
            [.message(message: "Тут ты можешь найти поздравления и интерактив твоих друзей")],
            [.message(message: "А еще тут всякие пасхалки")],
            [.message(message: "Попробуй нажать 'A' еще раз, будет интерактив")],
            [.hideMessage, .playCoins]
        ]
    }
    
    func maxActions() -> [[Action]] {
        return [
            [.message(message: "Привет Лида, это ЛИДАЛЕНД!!!!!")],
            [.message(message: "Тут ты можешь найти поздравления и интерактив твоих друзей")],
            [.message(message: "А еще тут всякие пасхалки")],
            [.message(message: "Попробуй нажать 'A' еще раз, будет интерактив")],
            [.hideMessage, .showMickey]
        ]
    }
    
    func shuraActions() -> [[Action]] {
        return [
            [.message(message: "Лииида, с днём рождения дорогая!")],
            [.message(message: "Наконец-то тебе 16 и мы можем разговаривать на взрослые темы.")],
            [.message(message: "Как тебе инфляция в Британии?")],
            [.hideMessage, .playCoins]
        ]
    }
}
