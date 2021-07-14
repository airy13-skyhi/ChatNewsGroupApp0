//
//  Util.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import Foundation
import UIKit
import Hex

class Util {
    
    
    
    static func rectButton(button:UIButton) {
        
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(hex: "#42c4cc")
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.white, for: .normal)
        
    }
    
    
    
}


