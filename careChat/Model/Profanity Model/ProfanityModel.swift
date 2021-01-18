//
//  ProfanityModel.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import Foundation

struct ProfanityModel{
    let bad_words_total: Int
    let content: String
    let censored_content: String
}

struct ProfanityData: Codable {
    let bad_words_total: Int
    let content: String
    let censored_content: String
}
