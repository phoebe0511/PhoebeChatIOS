//
//  SenderLargeChatCell.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/16.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.
//

import UIKit

class LeftLargeChatCell: BaseChatCell {

    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var messageBK: UIView!
    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var messageBody: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
