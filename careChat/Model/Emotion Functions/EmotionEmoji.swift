//
//  EmotionEmoji.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import Foundation
import UIKit

func emotionEmoji(emotion: String) -> String {
    switch emotion {
    case "joy":
        return "joy 😄"
    case "surprise":
        return "surprise 😮"
    case "sadness":
        return "sadness 🙁"
    case "anger":
        return "anger 😡"
    case "love":
        return "love 🥰"
    case "fear":
        return "fear 😰"
    default:
        return "mixed 🥴"
    }
}
