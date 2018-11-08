//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

func sumCGPoint(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func subCGPoint(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func getDirectionFromTouchPosition(startPoint s: CGPoint, endPoint e: CGPoint) -> Direction {
    if (e.y < s.y && abs(Int(e.x - s.x)) < abs(Int(s.y - e.y))) {
        return Direction.ToUp
    }
    if (e.y > s.y && abs(Int(e.x - s.x)) < abs(Int(s.y - e.y))) {
        return Direction.ToDown
    }
    if (e.x < s.x && abs(Int(e.y - s.y)) < abs(Int(s.x - e.x))) {
        return Direction.ToLeft
    }
    if (e.x > s.x && abs(Int(e.y - s.y)) < abs(Int(s.x - e.x))) {
        return Direction.ToRight
    }
    
    NSLog("FKDBG someproblems in getDirectionFromTouchPosition")
    return Direction.ToDown
}

//возвращает угол в зависимости от направления
func GetDegree (dir: Direction) -> CGFloat {
    switch dir {
    case .ToDown:
        return 0.0
    case .ToLeft:
        return (90.0 * .pi) / 180.0
    case .ToRight:
        return (270.0 * .pi) / 180.0
    case .ToUp:
        return (180.0 * .pi) / 180.0
    default:
        return 0.0
    }
}
