//
//  ProfanityViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit

class ProfanityViewController: UIViewController {
    
    let model = Emotion()

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var profaneLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Detect the emotion of your text"
        profaneLabel.text = "and check if it is profane."
    }
    
    @IBAction func detectPressed(_ sender: Any) {
        
        if let message = textField.text {
            do {
                let prediction = try model.prediction(input: EmotionInput(text: message))
                print(prediction.label)
                let emotion = emotionEmoji(emotion: prediction.label)
                resultLabel.text = "Emotion: \(emotion)"
            }
            catch  {
                fatalError("Cant predict emotion")
            }
        }
        
        if let text = textField.text {
            let model = detectProfanity(text: text)
            let count = model.bad_words_total
            profaneLabel.textColor = count>0 ? UIColor.red : UIColor.black
            profaneLabel.text = count>0 ? "Profane 😕" : "Not Profane! 😃"
            
        }
    }
}
