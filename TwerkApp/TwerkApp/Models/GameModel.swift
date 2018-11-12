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

let defaults = UserDefaults.standard

let SKIN_NICKI_NUM = 1
let SKIN_IGGI_NUM = 2
let SKIN_KIM_NUM = 3
let SKIN_BEYONCE_NUM = 4
let SKIN_MIA_NUM = 5
let SKIN_TRUMP_NUM = 6

class TwerkGame {
    var curArrow: Arrow
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
        curArrow = Arrow()
        
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
    }
    
    func PrepareForGame () {
        Score = 0
        curArrow = Arrow()
    }
    
    func PlayerEndedTurn (isCorrect: Bool)  {
        if isCorrect {
            if (curArrow.State == .Coin) {
                coins += 1
                defaults.set(coins, forKey: "coins")
            }
            Score += 1
            if (Score > bestScore) {
                bestScore = Score
                defaults.set(bestScore, forKey: "bestScore")
            }
            generateNewArrow()
            NSLog("FKDBG игрок сделал правильный ход")
        } else {
            NSLog("FKDBG проигрыш")
            EndGame()
        }
    }
    
    private func generateNewArrow () {
        curArrow.Randomise(ifCoin: Score > 20, ifDouble: Score > 10)
    }
    
    func EndGame () {
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
