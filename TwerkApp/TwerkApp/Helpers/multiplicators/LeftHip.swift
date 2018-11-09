//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

func getMultiplycatorForLeftHipX1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 19.5
    case SKIN_TRUMP_NUM:
        return 19.5
    default:
        return 19.5
    }
}

func getMultiplycatorForLeftHipX2(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 15
    default:
        return 15
    }
}

func getMultiplycatorForLeftHipY1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 28
    default:
        return 28
    }
}

func getMultiplycatorForLeftHipRot(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return CGFloat(Double.pi * 0.11)
    default:
        return CGFloat(Double.pi * 0.11)
    }
}
