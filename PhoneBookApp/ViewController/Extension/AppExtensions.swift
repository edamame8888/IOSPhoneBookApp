//
//  AppExtension.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/14.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//

import Foundation
import UIKit

/// TextField拡張
extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
