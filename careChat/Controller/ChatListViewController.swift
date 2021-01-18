//
//  ChatListViewController.swift
//  careChat
//
//  Created by Swamita on 18/01/21.
//

import UIKit
import Firebase

class chatListViewController: UIViewController {
    
    let db = Firestore.firestore()
    var messages : [Message] = []
    var emotionString = "Neutral"

    @IBOutlet weak var tableView: UITableView!
    
    var chats : [Chatlist] = [Chatlist(title: "Chat Group", image: UIImage(named: "profilePic")!, mood: "joy")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //self.navigationController?.navigationBar.barTintColor = UIColor(named: "SpoilGreen")
        loadMessages()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Spoil No More!"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - loadMessages()
    
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
                        }
                    }
                }
                self.emotionString = checkEmotion(messages: self.messages)
            }
        }
    }
    
}

//MARK: - UITableView Methods

extension chatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier")!
        cell.textLabel?.text = chats[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        cell.imageView?.image = chats[indexPath.row].image
        cell.accessoryType = UITableViewCell.AccessoryType.detailButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listToChat", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let message = UIAlertController(title: "Emotion", message: "The sentiment of this chat is \(emotionString)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
             //print("Ok button tapped")
          })
        message.addAction(action)
        self.present(message, animated: true, completion: nil)
    }
}
