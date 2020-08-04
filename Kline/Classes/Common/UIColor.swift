//
//  UIColor.swift
//  GzipSwift
//
//  Created by zhangj on 2020/8/4.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")

        var hexNumber: UInt32 = 0
        scanner.scanHexInt32(&hexNumber)
        
        let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexNumber & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexNumber & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
