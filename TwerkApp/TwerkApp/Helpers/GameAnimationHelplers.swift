//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

let MAX_X_TRANS_SHIFT = CGFloat(40.0)
let MAX_DELTA_Y = CGFloat(75.0)
let MAX_DELTA_X = CGFloat(50.0)
let MAX_Y_ROT_SHIFT = CGFloat(M_PI/6);
let MAX_Y_TRANS_SHIFT = CGFloat(100.0)

func normaliseDeltaForUpdatingAssPosition(delta: CGPoint) -> CGPoint {
    var curDelta = delta
    
    if(curDelta.y < -1 * MAX_DELTA_Y) {
        curDelta.y = -1 * MAX_DELTA_Y
    }
    if(curDelta.y > MAX_DELTA_Y) {
        curDelta.y = MAX_DELTA_Y
    }
    
    if (curDelta.x < -1*MAX_DELTA_X) {
        curDelta.x = -1*MAX_DELTA_X
    }
    if (curDelta.x > MAX_DELTA_X) {
        curDelta.x = MAX_DELTA_X
    }
    
    return curDelta
}

func createTransformForLeftAss(delta: CGPoint, personNum: Int) -> CGAffineTransform {
    return CGAffineTransform.identity
}

func createTransformForRightAss(delta: CGPoint, personNum: Int) -> CGAffineTransform {
    return CGAffineTransform.identity
}

func createTransformForLeftHip(delta: CGPoint, personNum: Int) -> CGAffineTransform {
    var res = CGAffineTransform.identity
    let scaleX = 1 + delta.x/MAX_DELTA_X/3
    let scaleY = myScale(minRes: 0.75, maxRes: 1.25, value: delta.y, minValue: -1 * MAX_DELTA_Y, maxValue: MAX_DELTA_Y)
    
    res = res.rotated(by: (delta.y / MAX_DELTA_Y)*getMultiplycatorForLeftHipRot(personNum: personNum))
    res = res.translatedBy(
        x: -1 * delta.x / MAX_DELTA_X * getMultiplycatorForLeftHipX1(personNum: personNum) +
            delta.y / MAX_DELTA_Y * getMultiplycatorForLeftHipX2(personNum: personNum),
        y: -1 * (delta.y / MAX_DELTA_Y) * getMultiplycatorForLeftHipY1(personNum: personNum)
    )
    res = res.scaledBy(x: scaleX, y: scaleY)
    
    return res
}

func createTransformForRightHip(delta: CGPoint, personNum: Int) -> CGAffineTransform {
    var res = CGAffineTransform.identity
    let scaleX = 1 + delta.x/MAX_DELTA_X/3
    let scaleY = myScale(minRes: 0.75, maxRes: 1.25, value: delta.y, minValue: -1 * MAX_DELTA_Y, maxValue: MAX_DELTA_Y)
    
    res = res.rotated(by: (delta.y / MAX_DELTA_Y) * getMultiplycatorForRightHipRot(personNum: personNum))
    res = res.translatedBy(
        x: -1 * delta.x / MAX_DELTA_X * getMultiplycatorForRightHipX1(personNum: personNum) +
            delta.y / MAX_DELTA_Y * getMultiplycatorForRightHipX2(personNum: personNum),
        y: -1 * (delta.y / MAX_DELTA_Y) * getMultiplycatorForRightHipY1(personNum: personNum)
    )
    res = res.scaledBy(x: scaleX, y: scaleY)
    
    return res
}

func createTransformForBack(delta: CGPoint, personNum: Int) -> CGAffineTransform {
    var res = CGAffineTransform.identity
    let scaleX = 1 + delta.x/MAX_DELTA_X/3
    let scaleY = myScale(minRes: 0, maxRes: 2.0, value: delta.y, minValue: MAX_DELTA_Y, maxValue: -1 * MAX_DELTA_Y)
    
    res = res.rotated(by: (delta.y / MAX_DELTA_Y)*getMultiplycatorForBackRot(personNum: personNum))
    res = res.translatedBy(
        x: -1 * delta.x / MAX_DELTA_X * getMultiplycatorForBackX1(personNum: personNum) +
            delta.y / MAX_DELTA_Y * getMultiplycatorForBackX2(personNum: personNum),
        y: -1 * (delta.y / MAX_DELTA_Y) * getMultiplycatorForBackY1(personNum: personNum)
    )
    res = res.scaledBy(x: scaleX, y: scaleY)
    
    return res
}
