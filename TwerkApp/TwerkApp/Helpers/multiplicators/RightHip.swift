//
//  Helpers.swift
//  TwerkApp
//
//  Created by mac on 08/11/2018.
//  Copyright © 2018 Filipp. All rights reserved.
//

import Foundation
import UIKit

func getMultiplycatorForRightHipX1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 22
    default:
        return 22
    }
}


func getMultiplycatorForRightHipX2(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 15.5
    default:
        return 15.5
    }
}

func getMultiplycatorForRightHipY1(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return 25
    default:
        return 25
    }
}

func getMultiplycatorForRightHipRot(personNum: Int) -> CGFloat {
    switch personNum {
    case SKIN_NICKI_NUM:
        return CGFloat(Double.pi * 0.09)
    default:
        return CGFloat(Double.pi * 0.09)
    }
}
