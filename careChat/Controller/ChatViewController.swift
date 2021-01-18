//
//  ChatViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    var sublayer = false
    
    let db = Firestore.firestore()
    let mlmodel = Emotion()
    var emotionString = "Neutral"
    
    var messages : [Message] = []
    
    var profane = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageIdentifier")
        tableView.register(UINib(nibName: "RecievedMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "recievedIdentfier")
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: -  LoadMessages()
    
    func loadMessages() {
        
        db.collection("messages")
            .order(by: "time")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error {
                print(e.localizedDescription)
            } else {
                
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let messageSender = data["sender"] as? String, let messageBody = data["body"] as? String, let messageProfanity = data["profane"] as? Bool, let messageEmotion = data["emotion"] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody, profane: messageProfanity, emotion: messageEmotion)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                    self.emotionString = checkEmotion(messages: self.messages)
                    print("emotion: \(self.emotionString)")
                    let color = emotionColor(emotion: self.emotionString)
                    self.changeBackground(color: color)
                }
            }
        }
    }
    
    let gradient: CAGradientLayer = CAGradientLayer()
    
    func changeBackground(color: UIColor) {
        if sublayer == true {
            gradient.removeFromSuperlayer()
        }
        
        //print("Color: \(color.accessibilityName)")
        gradient.colors = [UIColor.white.cgColor, color.cgColor]
        gradient.locations = [0.3 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        self.view.layer.insertSublayer(gradient, at: 0)
        sublayer = true
        //view.backgroundColor = color
    }
    
    //var colourIndex = 0
    //var colours = [UIColor.systemYellow, UIColor.systemGreen, UIColor.systemIndigo, UIColor.red, UIColor.systemPink, UIColor.systemPurple, UIColor.systemOrange]
    
    //MARK: - sendPressed()
    
    @IBAction func sendPressed(_ sender: UIButton) {
        /*var color = colours[colourIndex]
        changeBackground(color: color)
        colourIndex+=1*/
        
        if messageTextField.text == "" {
            showAlert(message: "Type something to send your message")
            
        } else {
            if let messageBody = messageTextField.text,let messageSender = Auth.auth().currentUser?.email {
                
                let emotion = findEmotion(text: messageBody)
                
                let censoredBody = detectBadWords(text: messageBody)
                if censoredBody == "" {
                    //print("Try without brackets")
                    self.showAlert(message: "Avoid using brackets in your messages")
                    
                } else {
                    db.collection("messages").addDocument(data: [
                                                            "sender" : messageSender,
                        "body":censoredBody,
                        "time":Date().timeIntervalSince1970,
                        "profane":profane,
                        "emotion":emotion
                        
                    ]) { (error) in
                        if let e = error {
                            self.showAlert(message: e.localizedDescription)
                        } else {
                            DispatchQueue.main.async {
                                self.messageTextField.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - detectBadWords()
    
    func detectBadWords(text: String) -> String {
        let model = detectProfanity(text: text)
        let censoredBody = model.censored_content
        
        let count = model.bad_words_total
        profane = count>0 ? true : false
        
        return censoredBody
    }
    
    //MARK: - findEmotion()
    
    func findEmotion(text: String) -> String {
        do {
            let prediction = try mlmodel.prediction(input: EmotionInput(text: text))
            print(prediction.label)
            return prediction.label
        }
        catch  {
            fatalError("Cant predict emotion")
            //return "Neutral"
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             //print("Ok button tapped")
          })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - UITableView Methods

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        if message.sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageIdentifier") as! MessageTableViewCell
            cell.messageLabel.text = message.body
            if message.profane == true{
                cell.messageBubble.backgroundColor = UIColor.red
            } else {
                cell.messageBubble.backgroundColor = UIColor.systemBlue
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recievedIdentfier") as! RecievedMessageTableViewCell
            cell.messageLabel.text = message.body
            cell.userLabel.text = message.sender
            
            if message.profane == true{
                cell.messageBubble.backgroundColor = UIColor.red
            } else {
                cell.messageBubble.backgroundColor = UIColor.systemGray
            }
            return cell
        }
        
    }
    
    
}
