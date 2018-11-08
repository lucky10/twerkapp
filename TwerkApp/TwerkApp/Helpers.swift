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
