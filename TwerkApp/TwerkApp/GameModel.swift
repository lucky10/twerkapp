//
//  GameModel.swift
//  TwerkApp
//
//  Created by mac on 27.01.18.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import AudioToolbox
import AVFoundation

let NUM_OF_ARROWS = 5

let defaults = UserDefaults.standard

let SKIN_NICKI_NUM = 1
let SKIN_IGGI_NUM = 2
let SKIN_KIM_NUM = 3
let SKIN_BEYONCE_NUM = 4
let SKIN_MIA_NUM = 5
let SKIN_TRUMP_NUM = 6


enum Direction {
    case ToLeft
    case ToRight
    case ToUp
    case ToDown
}

enum State {
    case Default
    case Coin
    case Empty
}

class Arrow {
    var Direct: Direction
    var State: State
    
    init() {
        Direct = .ToUp
        State = .Default
    }
    
    init(random: Bool, empty: Bool){
        Direct = .ToDown
        State = .Default
        if empty {
            State = .Empty
        }
        if (random){
            let forDirect = Int(arc4random_uniform(4))
            switch (forDirect){
            case 0:
                Direct = .ToUp
            case 1:
                Direct = .ToDown
            case 2:
                Direct = .ToLeft
            case 3:
                Direct = .ToRight
            default:
                Direct = .ToDown
            }
        }
    }
    
    func Randomise (ifCoin : Bool) {
        let forDirect = Int(arc4random_uniform(4))
        switch (forDirect){
        case 0:
            Direct = .ToUp
        case 1:
            Direct = .ToDown
        case 2:
            Direct = .ToLeft
        case 3:
            Direct = .ToRight
        default:
            Direct = .ToDown
        }
        if ifCoin {
            let forCoin = Int(arc4random_uniform(10))
                switch (forCoin){
                case 1:
                    State = .Coin
                default:
                    State = .Default
                }
        } else {
            State = .Default
        }
    }
}

class TwerkGame {
    var Arrows = [Arrow]()
    var ifGame: Bool
    var Score: Int
    var bestScore: Int
    var coins: Int
    var ifShowReplay: Bool
    var ifVibration: Bool
    var ifSound: Bool
    var ifShowAds: Bool
    var personNum: Int
    
    init () {
        ifGame = false
        Score = 0
        ifShowReplay = true
        //тут должна быть подгрузка из DataCore или ещё откуда нибудь
        bestScore = defaults.integer(forKey: "bestScore")
        coins = defaults.integer(forKey: "coins")
        ifVibration = defaults.bool(forKey: "ifVibration")
        ifSound = defaults.bool(forKey: "ifSound")
        ifShowAds = defaults.bool(forKey: "ifShowAds")
        personNum = defaults.integer(forKey: "personNum")
        if (personNum == 0) {
            defaults.set(1, forKey: "personNum")
            personNum = 1
        }
        personNum = 4
    }
    
    func PrepareForGame () {
        Score = 0
        for _ in 0...NUM_OF_ARROWS {
            Arrows.append(Arrow(random: true, empty: false))
        }
    }
    
    func PlayerEndedTurn (onPosition position: Direction, withDelta delta: Double) -> Bool {
        //если закончил слишком далеко
        if (delta >= 1.0) {
            EndGame()
            return false
        }
        guard let curFirst = Arrows.first else {
            NSLog ("FKDBG problems with PlayerEndedTurn in GameModel")
            return false
        }
        if (position == curFirst.Direct){
            RandomiseLastArrow()
            if (curFirst.State == .Coin) {
                coins += 1
                defaults.set(coins, forKey: "coins")
            }
            Score += 1
            if (Score > bestScore) {
                bestScore = Score
                defaults.set(bestScore, forKey: "bestScore")
            }
            Arrows.append(Arrows.removeFirst())
            NSLog("FKDBG игрок сделал правильный ход")
            return true
        } else {
            NSLog("FKDBG игрок проебал, потому что дернул в сторону \(position) а надо было \(curFirst.Direct)")
            EndGame()
            return false
        }
    }
    
    func RandomiseLastArrow () {
        if let curLast = Arrows.last {
            if (Score > 10) {
                curLast.Randomise(ifCoin: true)
            } else {
                curLast.Randomise(ifCoin: false)
            }
        }
    }
    func RandomiseAll (){
        for curArrow in Arrows {
            curArrow.Randomise(ifCoin: false)
        }
    }
    
    func EndGame () {
        NSLog ("FKDBG игрок проебал")
        if ifVibration {
            // kSystemSoundID_Vibrate
            // магическое число отвечающее за вибрацию в любом режиме
            AudioServicesPlaySystemSound(1352)
        }
        ifGame = false
    }
    
    func changeSoundSettings () {
        ifSound = !ifSound
        defaults.set(ifSound, forKey: "ifSound")
    }
    
    func changeVibrationSettings () {
        ifVibration = !ifVibration
        defaults.set(ifVibration, forKey: "ifVibration")
    }
    
    func changeSkinSettings (toValue v: Int) {
        personNum = v
        defaults.set(v, forKey: "personNum")
    }
}
