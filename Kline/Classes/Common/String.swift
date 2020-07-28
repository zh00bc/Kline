//
//  String.swift
//  kline
//
//  Created by zhangj on 2019/5/28.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

extension String {
    func width(using font: UIFont) -> CGFloat {
        let text = self as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let textSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(textSize.width)
    }
    
    func height(using font: UIFont) -> CGFloat {
        let text = self as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let textSize = text.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(textSize.height)
    }
}
