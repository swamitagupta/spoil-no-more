//
//  CheckEmotion.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import Foundation
import UIKit

func checkEmotion(messages: [Message]) -> String{
    var emoList: [String] = []
    if messages.count == 0 {
        return "Neutral"
    }
    else {
        if messages.count < 8{
            for index in 0...messages.count-1 {
                let emotion = messages[index].emotion
                emoList.append(emotion)
            }
        } else {
            for index in (messages.count-7)...(messages.count-1) {
                let emotion = messages[index].emotion
                emoList.append(emotion)
            }
        }
        
        var counts: [String: Int] = [:]
        for item in emoList {
            counts[item] = (counts[item] ?? 0) + 1
        }
        let sortedCounts = counts.sorted { $0.1 > $1.1 }
        let max = sortedCounts[0].value

        var emotions: [String] = []
        
        for (key, value) in sortedCounts {
            if value == max {
                emotions.append(key)
            }
        }
        var emoString = emotions[0]
        
        if emotions.count > 1 {
            emoString = "mixed: \(emotions[0])"
            for index in 1...emotions.count-1 {
                emoString = emoString + ", " + emotions[index]
            }
        }
        
        return emoString
    }
    
}
