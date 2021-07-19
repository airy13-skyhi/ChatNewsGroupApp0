//
//  ChatViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/16.
//

import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView
import SDWebImage
import Hex
import AVKit

struct Sender:SenderType {
    
    var senderId:String
    var displayName:String
    
}


//アバターに使える機能 by Github
class ChatViewController: MessagesViewController, MessagesLayoutDelegate, MessagesDataSource, MessagesDisplayDelegate, InputBarAccessoryViewDelegate, MessageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    var userModel:UserModel?
    var chatRoomDetail:ChatRoomDetail?
    
    
    //me
    var currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
    
    //other
    var otherUser = Sender(senderId: "", displayName: "")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        

        
    }
    
    
    
    func currentSender() -> SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        <#code#>
    }

    
}
