//
//  Message.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/19.
//

import Foundation
import MessageKit

//messageの内容を一まとめにした構造体
struct Message:MessageType {
    
    var sender:SenderType
    var messageId:String
    var sentDate:Date
    var kind:MessageKind
    
    //original
    var userImagePath:String
    var date:Double
    var messageImageString:String
    var thumbnailURLString:String
    
    
}


struct ImageMediaItem:MediaItem {
    
    
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image:UIImage) {
        
        
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        
    }
    
    
    init(imageURL:URL) {
        
        self.url = imageURL
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        
    }
    
    
}


