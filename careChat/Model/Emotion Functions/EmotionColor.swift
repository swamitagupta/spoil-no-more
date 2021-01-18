//
//  EmotionColor.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import Foundation
import UIKit

func emotionColor(emotion: String) -> UIColor {
    switch emotion {
    case "joy":
        return UIColor.systemYellow
    case "surprise":
        return UIColor.systemGreen
    case "sadness":
        return UIColor.systemIndigo
    case "anger":
        return UIColor.red
    case "love":
        return UIColor.systemPink
    case "fear":
        return UIColor.systemPurple
    default:
        return UIColor.systemOrange
    }
}
