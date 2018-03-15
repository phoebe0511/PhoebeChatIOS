//
//  ViewController.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/14.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.

import UIKit
import Firebase
//import Crashlytics

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var cellArray : [ChatCell] = [ChatCell]()
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
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        messageTextHeight = heightOfMsgView.constant
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        messageTableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        messageTableView.separatorStyle = .none

        receiveFirebaseDB()
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        //let cell = ChatCell.init(style: .default, reuseIdentifiecellArrayr: "ChatCell")
        //let array = ["12", "efgb dfs dfghnjkl;675tefdsawergthyjkjhgf ghjkl;';lkjh", "eeeeee"]
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderName.text = messageArray[indexPath.row].sender
        cell.senderImageView.image = UIImage(named: "senderIcon")
        
        let frame = calculateStringWidth(with: cell.messageBody.text!)

        var constraint = NSLayoutConstraint(item: cell.messageBody, attribute: .trailing, relatedBy: .equal, toItem: cell.messageBackground, attribute: .trailing, multiplier: 1, constant: (-15))
        cell.messageBackground.addConstraint(constraint)
        
        var leading_msgBody : CGFloat = 0
        var tailing_msgBody : CGFloat = 0
        
        if cell.senderName.text == Auth.auth().currentUser?.email{
            cell.bubbleImageView.image = UIImage(named: "talkbubble2")?.resizableImage(withCapInsets: UIEdgeInsetsMake(25, 25, 25, 25)).withRenderingMode(.alwaysTemplate)
            cell.bubbleImageView.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.senderImageView.isHidden = true
            cell.senderName.isHidden = true
            cell.messageBody.textColor = UIColor.white
            tailing_msgBody = -30
            if(frame.width > cell.frame.width - cell.senderImageView.frame.width - 10){
                leading_msgBody = 60
            }else{
                leading_msgBody = messageTableView.frame.width - frame.width - 100
            }
        }else{
            cell.bubbleImageView.image = UIImage(named: "talkbubble1")?.resizableImage(withCapInsets: UIEdgeInsetsMake(25, 25, 25, 25)).withRenderingMode(.alwaysTemplate)
            cell.bubbleImageView.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            cell.senderImageView.isHidden = false
            cell.senderImageView.backgroundColor = UIColor.green
            
            leading_msgBody = 15
            if(frame.width > messageTableView.frame.width - cell.senderImageView.frame.width - 100){
                tailing_msgBody = -30
            }else{
                tailing_msgBody = (messageTableView.frame.width - frame.width - 100) * -1
            }
        }
        
        //leading_bubble = leading_msgBody - 15
        //tailing_bubble = tailing_msgBody + 15
        
//        constraint = NSLayoutConstraint(item: cell.messageBody, attribute: .leading, relatedBy: .equal, toItem: cell.messageBackground, attribute: .leading, multiplier: 1, constant: leading_msgBody)
//        cell.messageBackground.addConstraints([constraint])
//
//        constraint = NSLayoutConstraint(item: cell.messageBody, attribute: .trailing, relatedBy: .equal, toItem: cell.messageBackground, attribute: .trailing, multiplier: 1, constant: tailing_msgBody)
//        cell.messageBackground.addConstraints([constraint])
        cell.messageBody.leadingAnchor.constraint(equalTo: cell.messageBackground!.leadingAnchor, constant: leading_msgBody).isActive = true
        cell.messageBody.trailingAnchor.constraint(equalTo: cell.messageBackground!.trailingAnchor, constant: tailing_msgBody).isActive = true
        
        constraint = NSLayoutConstraint(item: cell.bubbleImageView, attribute: .leading, relatedBy: .equal, toItem: cell.messageBody, attribute: .leading, multiplier: 1, constant: -15)
        cell.messageBackground.addConstraints([constraint])
        
        constraint = NSLayoutConstraint(item: cell.bubbleImageView, attribute: .trailing, relatedBy: .equal, toItem: cell.messageBody, attribute: .trailing, multiplier: 1, constant: 15)
        cell.messageBackground.addConstraints([constraint])
        
        //cell.messageBackground.bringSubview(toFront: cell.messageBody)
        //cell.messageBody.backgroundColor = UIColor.green
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    

    @objc func tableViewTapped(){
        messageTextfield.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.5) {
//            self.heightConstraint.constant = (self.keyboardRect?.height)! + 50
//            self.view.layoutIfNeeded()
//        }
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
