//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

func getMultiplycatorForBackX1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 22
    default:
        return 22
    }
}


func getMultiplycatorForBackX2(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 15.5
    default:
        return 15.5
    }
}

func getMultiplycatorForBackY1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 20
    default:
        return 20
    }
}

func getMultiplycatorForBackRot(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return CGFloat(Double.pi * 0.2)
    default:
        return CGFloat(Double.pi * 0.2)
    }
}
