//
//  ArrowModel.swift
//  TwerkApp
//
//  Created by mac on 09/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation

enum Direction {
    case ToLeft
    case ToRight
    case ToUp
    case ToDown
}

enum State {
    case Default
    case Coin
}

enum ArrowPosition {
    case End
    case Middle
    case Begin
}

class Arrow {
    var Direct: Direction
    var State: State
    var isDouble: Bool
    
    init() {
        Direct = .ToUp
        State = .Default
        isDouble = false
    }
    
    init(random: Bool){
        Direct = .ToDown
        State = .Default
        isDouble = false
        
        if (random){
            randomiseDirect()
        }
    }
    
    func Randomise (ifCoin : Bool, ifDouble: Bool) {
        randomiseDirect()
        if ifCoin {
            randomiseCoin()
        }
        if ifDouble {
            randomiseDouble()
        }
    }
    
    private func randomiseDirect() {
        let seed = Int(arc4random_uniform(4))
        switch (seed){
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
    
    private func randomiseCoin() {
        let seed = Int(arc4random_uniform(10))
        switch (seed){
        case 1:
            State = .Coin
        default:
            State = .Default
        }
    }
    
    private func randomiseDouble() {
        let seed = Int(arc4random_uniform(10))
        switch (seed){
        case 1:
            isDouble = true
        default:
            isDouble = false
        }
    }
}
