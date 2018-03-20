//
//  ViewController.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/14.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    // Declare instance variables here
    var messageArray : [Message] = [Message]()

    let DATABASE_REF_NAME = "Messages"
    // We've pre-linked the IBOutlets

    @IBOutlet weak var heightOfMsgView: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    var messageTextHeight : CGFloat = 0
    
    var keyboardRect : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GradientColor(.diagonal, frame: self.view.frame, colors: [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)])
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        messageTextHeight = heightOfMsgView.constant
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        messageTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        messageTableView.separatorStyle = .none
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.receiveFirebaseDB()
        receiveFirebaseDB()
        let nibName = UINib(nibName: "LeftChatCell", bundle: nil)
        messageTableView.register(nibName, forCellReuseIdentifier: "leftCell")
        let nibNameLL = UINib(nibName: "LeftLargeChatCell", bundle: nil)
        messageTableView.register(nibNameLL, forCellReuseIdentifier: "leftLargeCell")
        let nibNameR = UINib(nibName: "RightChatCell", bundle: nil)
        messageTableView.register(nibNameR, forCellReuseIdentifier: "rightCell")
        let nibNameRL = UINib(nibName: "RightLargeChatCell", bundle: nil)
        messageTableView.register(nibNameRL, forCellReuseIdentifier: "rightLargeCell")
    }
    
    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        keyboardRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print("!!!keyboardFrame: \(keyboardRect!)")
        UIView.animate(withDuration: 0.5) {
            self.heightOfMsgView.constant = (self.keyboardRect?.height)! + self.messageTextHeight
            //self.heightOfMsgView.constant = 400
            self.view.layoutIfNeeded()
        }
    }
    
    func calculateStringWidth(with str : String) -> CGRect {
        let size = CGSize(width: 2000, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: str).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        print(estimatedFrame)
        return estimatedFrame
    }
    
    func ifLargeCell(framLength len : Int) -> Bool {
        let cellWidth = messageTableView.safeAreaLayoutGuide.layoutFrame.width
        return len > Int(cellWidth - 50.0)
    }
    
    func tableScrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numRows = self.messageTableView.numberOfRows(inSection: 0)
            if numRows > 0{
                let indexPath = IndexPath(row: numRows - 1, section: 0)
                self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let frame = calculateStringWidth(with: messageArray[indexPath.row].messageBody)
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email{
            if ifLargeCell(framLength: Int(frame.width)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightLargeCell", for: indexPath) as! RightLargeChatCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.initBubbleImage(imageView: cell.bubbleImageView, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), picName: "talkbubble2")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath) as! RightChatCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.initBubbleImage(imageView: cell.bubbleImage, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), picName: "talkbubble2ss")
                return cell
            }
        }else{
            if ifLargeCell(framLength: Int(frame.width)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftLargeCell", for: indexPath) as! LeftLargeChatCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.initBubbleImage(imageView: cell.bubbleImage, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), picName: "talkbubble1")
                cell.senderName.text = messageArray[indexPath.row].sender
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath) as! LeftChatCell
                cell.messageBody.text = messageArray[indexPath.row].messageBody
                cell.initBubbleImage(imageView: cell.bubbleImageView, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), picName: "talkbubble1")
                cell.senderName.text = messageArray[indexPath.row].sender
                return cell
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    

    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.heightOfMsgView.constant = self.messageTextHeight
            self.view.layoutIfNeeded()
        }
    }

    
    ///////////////////////////////////////////
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        //Crashlytics.sharedInstance().crash()

        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        let messagesDB = Database.database().reference().child(DATABASE_REF_NAME)
        let messageDictionary = ["Sender" : Auth.auth().currentUser?.email, "MessageBody" : messageTextfield.text]
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                print("Message saved successfully!")
                self.messageTextfield.isEnabled = true
                self.messageTextfield.text = ""
                self.sendButton.isEnabled = true
                self.tableScrollToBottom()
            }
        }
        
    }
    

    func receiveFirebaseDB(){
        let messageDB = Database.database().reference().child(DATABASE_REF_NAME)

        messageDB.observe(.childAdded) { (datasnapshot) in
            let snapshotValue = datasnapshot.value as! Dictionary<String, String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            print(sender, text)
            let message = Message()
            message.messageBody = text
            message.sender = sender
            self.messageArray.append(message)
            self.messageTableView.reloadData()
            self.tableScrollToBottom()
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        do{
            try Auth.auth().signOut()
            guard(navigationController?.popToRootViewController(animated: true)) != nil
                else {
                    print("No View Controllers to pop off")
                    return
            }
        }catch{
            print("error, there was a problem signing out.")
        }
    }
    


}
