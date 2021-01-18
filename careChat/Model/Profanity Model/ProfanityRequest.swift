//
//  ProfanityRequest.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import Foundation

//MARK: - detectProfanity()

func detectProfanity(text: String) -> ProfanityModel {
    var semaphore = DispatchSemaphore (value: 0)
    let parameters = text //"{body}"
    let postData = parameters.data(using: .utf8)
    let apikey = "6OA3R6KY8pETmPa6ftd1pMU2EHRAmRdt"
    var model = ProfanityModel(bad_words_total: 0, content: "", censored_content: "")

    let url = "https://api.promptapi.com/bad_words?censor_character=*"
    var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
    request.httpBody = postData
    request.httpMethod = "POST"
    request.addValue(apikey, forHTTPHeaderField: "apikey")

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        return
      }
        if let pd = parseJSON(data){
            model = pd
        }
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
    return model
}

//MARK: - parseJSON()

func parseJSON(_ profanityData: Data) -> ProfanityModel? {
    let decoder = JSONDecoder()
    do{
        let decodedData = try decoder.decode(ProfanityData.self, from: profanityData)
        let content = decodedData.content
        let censored_content = decodedData.censored_content
        let bad_words_total = decodedData.bad_words_total
        
        let profanity = ProfanityModel(bad_words_total: bad_words_total, content: content, censored_content: censored_content)
        return profanity
    } catch {
        print(error)
        return nil
    }
}

