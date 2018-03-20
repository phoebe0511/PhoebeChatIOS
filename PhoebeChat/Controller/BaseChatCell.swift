//
//  BaseChatCell.swift
//  PhoebeChat
//
//  Created by Hsiu Ping Lin on 2018/3/19.
//  Copyright © 2018年 Hsiu Ping Lin. All rights reserved.
//

import UIKit


class BaseChatCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func initBubbleImage(imageView : UIImageView, color : UIColor, picName : String) {
        imageView.image = UIImage(named: picName)?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 22, 22, 22)).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
    }
}
