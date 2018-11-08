//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

func getSpeedFromScore(Score: Int) -> Double {
    if Score >= 120 {
        return 0.1
    }
    if Score >= 80 {
        return 0.11
    }
    if Score >= 40 {
        return 0.12
    }
    if Score >= 20 {
        return 0.13
    }
    if Score >= 10 {
        return 0.14
    }
    if Score >= 0 {
        return 0.15
    }
    return 0.16
}
