//
//  TalkController.swift
//  Lida2022
//
//  Created by Alexander Zimin on 14/09/2022.
//

import Foundation

enum Person: String, CaseIterable {
    case alex = "Player_Alex"
    case max = "Player_Max"
    case shura = "Player_Shura"
    case kirillAv = "Player_Kirill"
    case grishaIlvina = "Player_Grisha_Ilvina"
    case kirillMar = "Player_Kirill_Mar"
    case nikolay = "Player_Nikolay"
    case kriss = "Player_Kriss"
    case krylove = "Player_Krylov"
    case glazunov = "Player_And_Rita"
    case sasha = "Player_Sasha"
}

class TalkController {
    static var shared = TalkController()
    
    enum Action {
        case message(message: String)
        case hideMessage
        case enterLidaland
        case playCoins
        case showMickey
        case showPostcard
        case playHahaSound
        case doMushroom
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
        case .kirillAv:
            actions = kirillAvActions()
        case .grishaIlvina:
            actions = grishaIlvinaActions()
        case .kirillMar:
            actions = kirillMarActions()
        case .nikolay:
            actions = nikolayActions()
        case .kriss:
            actions = krissActions()
        case .krylove:
            actions = krissActions()
        case .glazunov:
            actions = krissActions()
        case .sasha:
            actions = krissActions()
        case .none:
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
    
    var enteredLidaLandFlag = false
    
    func alexActions() -> [[Action]] {
        if (enteredLidaLandFlag) {
            return [
                [.message(message: "Да, это ЛИДАЛЕНД!!!!!")],
                [.message(message: "Тут ты можешь найти поздравления и интерактив твоих друзей")],
                [.message(message: "А еще тут всякие пасхалки")],
                [.hideMessage]
            ]
        } else {
            return [
                [.message(message: "Привет Лида, это ЛИДАЛЕНД!!!!!")],
                [.message(message: "Тут ты можешь найти поздравления и интерактив твоих друзей")],
                [.message(message: "А еще тут всякие пасхалки")],
                [.message(message: "Готова отправиться туда?")],
                [.hideMessage, .enterLidaland]
            ]
        }
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
    
    func kirillAvActions() -> [[Action]] {
        return [
            [.message(message: "Самая добрая, умная, строгая,\nВы — эталон, образец, идеал.")],
            [.message(message: "Вы покорили своими уроками\nВсех, кто вас с первого класса узнал.")],
            [.message(message: "Чуткая, честная и справедливая −\nУченики так про вас говорят.")],
            [.message(message: "Ваш день рождения — дата счастливая,\nКаждый поздравить Вас искренне рад.")],
            [.message(message: "Счастья огромного Вам и терпения,\nРадости, света, здоровья, тепла.")],
            [.message(message: "И бесконечного просто везения,\nИ чтоб зарплата росла и росла.")],
            [.message(message: "Пусть берегут Вас в семье, как жемчужину,\nДарят заботу, уют и покой.")],
            [.message(message: "Все это Вами, конечно, заслужено,\nЗа Ваш характер такой золотой.")],
            [.hideMessage, .showPostcard]
        ]
    }
    
    func kirillMarActions() -> [[Action]] {
        return [
            [.message(message: "Лииида ты прекрасна!")],
            [.message(message: "Больше тебе танцев и мур мур мур. Приезжайте в гости!")],
            [.hideMessage]
        ]
    }
    
    func grishaIlvinaActions() -> [[Action]] {
        return [
            [.message(message: "Вау! Как кайфово в лидаленде. Знаешь кстати куда бы ты здесь гнала трафик?")],
            [.message(message: "На Лидалендинг 🤭"), .playHahaSound],
            [.message(message: "Уверены, что ты в голос смеешься от этого каламбура. И хотим пожелать по-настоящему качественного юмора…")],
            [.message(message: "Безумных путешествий и новых побед (кроме монополий с нами). И главное - будь счастлива. Любим тебя ❤️")],
            [.hideMessage]
        ]
    }
    
    func nikolayActions() -> [[Action]] {
        return [
            [.message(message: "Лида, с днем рождения!")],
            [.message(message: "Расти большой, вот тебе мой подарок!")],
            [.hideMessage, .doMushroom]
        ]
    }
    
    func krissActions() -> [[Action]] {
        return [
            [.message(message: "Сладкая булочка, поздравляю тебя с твоим днем, очень скучаю и желаю всего самого самого, ты лучшее солнышко на свете.")],
            [.message(message: "Сильно ценю, что даже сквозь тысячи км и времени, мы остаёмся друзьями.")],
            [.message(message: "Люблю тебя и крепко обнимаю. А самое главное помни, расти большой, не будь лапшой! ❤️")],
            [.hideMessage]
        ]
    }
}
