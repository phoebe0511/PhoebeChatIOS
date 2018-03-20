//
//  RightChatCell.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/16.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.
//

import UIKit

class RightChatCell: BaseChatCell {

    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var messageBK: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
