//
//  LeftChatCell
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/16.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.

import UIKit

class LeftChatCell: BaseChatCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet var senderImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    

}
