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
    case sergey = "Player_Sergey"
    case masha = "Player_Masha"
    case ed = "Player_Ed"
    case sveta = "Player_Sveta"
    case sam = "Player_Sam"
    case casper = "Player_Casper"
    case nick = "Player_Nic"
    case marat = "Player_Marat"
    case kostya = "Player_Kostya"
    case gerald = "Player_Gerald"
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
            actions = kryloveActions()
        case .glazunov:
            actions = glazunovActions()
        case .sasha:
            actions = sashaActions()
        case .sergey:
            actions = sergeyActions()
        case .masha:
            actions = mashaActions()
        case .ed:
            actions = edActions()
        case .sveta:
            actions = svetaActions()
        case .sam:
            actions = samActions()
        case .casper:
            actions = casperActions()
        case .nick:
            actions = nickActions()
        case .marat:
            actions = maratActions()
        case .kostya:
            actions = costyaActions()
        case .gerald:
            actions = geraldActions()
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
            [.message(message: "Вау, Лидаленд такой классный, никак не могу здесь разобраться. Не то что в Дисснейленде.")],
            [.message(message: "Так много всего интересного, но я решил присесть тут пока что отдохнуть.")],
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
    
    func kryloveActions() -> [[Action]] {
        return [
            [.message(message: "Йо, с дарэ Лидос!")],
            [.message(message: "Половина полтинника это четвертак.")],
            [.message(message: "А четвертак попахивает неплохим названием для твоего рэп карьеры.")],
            [.message(message: "Главное в успешный рэп карьера, это здоровье, улыбка, охлажденное трахание.")],
            [.message(message: "Не двигай путь. Успех!")],
            [.hideMessage]
        ]
    }
    
    func glazunovActions() -> [[Action]] {
        return [
            [.message(message: "Андрей: Я: Эй, йо! Лида значит лидер!")],
            [.message(message: "Поэтому ты ЛЕГОндарная!😏")],
            [.message(message: "Оставайся такой же крэйзи шуга бэйбой с раскошным окружением и кайфовыми идеями.")],
            [.message(message: "Ри: «красотка, с днём рождения! Люби и будь любимой❤️")],
            [.message(message: "А главное, живи здесь и сейчас! Ююююхуууу")],
            [.hideMessage]
        ]
    }
    
    func sashaActions() -> [[Action]] {
        return [
            [.message(message: "Лида, поздравляю тебя с днём рождения!")],
            [.message(message: "Желаю быть самой счастливой и успешной в своих начинаниях.")],
            [.message(message: "P.S. Можешь сколько угодно жить в Лондоне и наслаждаться работой...")],
            [.message(message: "...но какой в этом толк, если мы все ещё не продаём энергетические камни на Бали.")],
            [.message(message: "P.P.S. тебя не пустят в Украину потому что ты Бомба!")],
            [.hideMessage]
        ]
    }
    
    func sergeyActions() -> [[Action]] {
        return [
            [.message(message: "С днём варенья, Лида! ")],
            [.message(message: "Желаю тебе побольше приятных впечатлений от жизни")],
            [.message(message: "Чтобы каждый день было куча всего интересного и вкусного вокруг! ")],
            [.message(message: "Чтобы рядом были только самые кайфовые люди.")],
            [.message(message: "И побольше тебе захватывающих путешествий!")],
            [.message(message: "Всегда оставайся такой же жизнерадостной и позитивной! 🥳")],
            [.hideMessage]
        ]
    }
    
    func mashaActions() -> [[Action]] {
        return [
            [.message(message: "Лида, с твоим днем!")],
            [.message(message: "Всего тебе крутого в этом году, еще больше путешествий и enjoy Londonnn ❤️")],
            [.hideMessage]
        ]
    }
    
    func edActions() -> [[Action]] {
        return [
            [.message(message: "Eсли я что то и знаю в жизни, то очень важно быть счастливым, и как можно больше!")],
            [.message(message: "Желаю тебе, Лида, много мнгого счастья и всенепременно с ароматом больших денег!")],
            [.hideMessage]
        ]
    }
    
    func svetaActions() -> [[Action]] {
        return [
            [.message(message: "Лииииидааааа! С днём рождения тебя, шикарная фенси-секси гёл.")],
            [.message(message: "Я очень тебя люблю и желаю счастья на максималках. Ты лучшая и со всем справишься!")],
            [.message(message: "Пусть год принесет тебе ярких событий, море удовольствия и кучу эмоций.")],
            [.message(message: "Крепко обнимаю 💙")],
            [.hideMessage]
        ]
    }
    
    func samActions() -> [[Action]] {
        return [
            [.message(message: "Ммм. Лида есть прекрасное, чудесное и осознанное мгновение лучшего образа себя")],
            [.hideMessage]
        ]
    }
    
    func casperActions() -> [[Action]] {
        return [
            [.message(message: "Лида, ты самая секси вайбс чикса на планете Земля!")],
            [.message(message: "Я тебя очень люблю и вспоминаю всегда нашу ночь у меня!")],
            [.message(message: "С днем рождения крошка, пусть все будет лакшери просто!!!")],
            [.hideMessage]
        ]
    }
    
    func nickActions() -> [[Action]] {
        return [
            [.message(message: "Лида, поздравляем тебя с днём рождения!")],
            [.message(message: "Желаем, что бы вы отлично обустроились, нашли много крутых знакомых")],
            [.message(message: "чтобы ты нашла самую классную работу в Лондоне, что бы все шло так,  как хотелось бы тебе. ")],
            [.message(message: "Продолжай всех радовать в сторис потрясающими историями из своей жизни)")],
            [.hideMessage]
        ]
    }
    
    func maratActions() -> [[Action]] {
        return [
            [.message(message: "Privet leeeeeeeeeeda")],
            [.message(message: "Kak tut zdorovo u tebya v metaverse 🤩")],
            [.message(message: "Pozdravlyayu s Dnem rozhdeniya! Vsegda ostavaysya samoy luchshey! Zhdem bolshe interesnyh stories 👏🏼")],
            [.message(message: "Sorry za T9")],
            [.message(message: "Press F")],
            [.hideMessage]
        ]
    }
    
    func costyaActions() -> [[Action]] {
        return [
            [.message(message: "С днём рождения.")],
            [.message(message: "Береги здоровье, не будь камнем, люблю!")],
            [.hideMessage]
        ]
    }
    
    func geraldActions() -> [[Action]] {
        return [
            [.message(message: "Я \"asshole\" и не придумал текст")],
            [.message(message: "Добавь, после этого с днём рождения")],
            [.hideMessage]
        ]
    }
}
