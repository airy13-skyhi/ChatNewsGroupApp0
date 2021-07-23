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
    
    
    
    let db = Firestore.firestore()
    let imageView = UIImageView()
    let blackView = UIView()
    
    
    
    var userModel:UserModel?
    var chatRoomDetail:ChatRoomDetail?
    
    
    //me
    var currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
    
    //other
    var otherUser = Sender(senderId: "", displayName: "")
    
    var messages = [Message]()
    
    //添付する画像を編集する機能
    var attachImage:UIImage?
    var attachImageString = String()
    
    var participateArray = [UserModel]()
    var thumbnailURLString:String?
    
    var formatter:DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        return formatter
        
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messagesCollectionView.backgroundColor = .clear
        
        let imageView = UIImageView(frame: view.bounds)
        
        imageView.sd_setImage(with: URL(string: chatRoomDetail!.backgroundImage), completed: nil)
        imageView.layer.zPosition = 1
        view.addSubview(imageView)
        messagesCollectionView.layer.zPosition = 2
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: userModel!.name)
        otherUser = Sender(senderId: userModel!.uid, displayName: userModel!.name)
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        
        maintainPositionOnKeyboardFrameChanged = true
        
        messageInputBar.sendButton.setTitle("送信", for: .normal)
        
        
        let newMessageInputBar = InputBarAccessoryView()
        newMessageInputBar.delegate = self
        
        messageInputBar = newMessageInputBar
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.layer.borderWidth = 0.0
        
        let items = [
            
            makeButton(image: UIImage(named: "info")!, buttonType: "B").onTextViewDidChange({ button, textView in
                
                button.isEnabled = textView.text.isEmpty
            }),
            
            makeButton(image: UIImage(named: "album")!, buttonType: "A").onTextViewDidChange({ button, textView in
                
                button.isEnabled = textView.text.isEmpty
            })
        ]
        
        messageInputBar.setLeftStackViewWidthConstant(to: 100, animated: true)
        messageInputBar.setStackViewItems(items, forStack: .left, animated: true)
        
        
        reloadInputViews()
    }
    
    
    func makeButton(image:UIImage,buttonType:String)->InputBarButtonItem{
        
        
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = image.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onSelected {
                $0.tintColor = .systemBlue
                if buttonType == "A"{
                    self.openCamera()
                    
                }else{
                    self.tapInfo()
                }
            }.onDeselected {
                
                $0.tintColor = UIColor.lightGray
                
            }
        
    }
    
    
    
    func tapInfo() {
        
        
        
    }
    
    
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            //画像と動画の選択画面
            cameraPicker.mediaTypes = ["public.image", "public.movie"]
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            //            cameraPicker.showsCameraControls = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let sendDBModel = SendDBModel()
        
        //画像だったら
        if let pickedImage = info[.editedImage] as? UIImage {
            
            attachImage = pickedImage
            sendDBModel.sendImageData(image: attachImage!, senderID: Auth.auth().currentUser!.uid, userModel: userModel!, docID: chatRoomDetail!.docID)
        }
        
        
        //動画だったら
        if let pickedVideo = info[.mediaURL] as? URL {
            
            do {
                
                let asset = AVAsset(url: pickedVideo)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                imageGenerator.appliesPreferredTrackTransform = true
                
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let imageRef = Storage.storage().reference().child("Thumbnail").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
                
                imageRef.putData(UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.3)!, metadata: nil) { metadata, error in
                    
                    if error != nil {
                        return
                    }
                    
                    
                    imageRef.downloadURL { url, error in
                        
                        if error != nil {
                            return
                        }
                        
                        
                        sendDBModel.sendVideoData(videoURL: pickedVideo, senderID: Auth.auth().currentUser!.uid, userModel: self.userModel!, docID: self.chatRoomDetail!.docID, thumbnail: url!.absoluteString)
                        
                        
                        
                    }
                    
                    
                }
                
            } catch  {
                
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //message受信
        loadMessage()
    }
    
    
    func loadMessage() {
        
        db.collection("Rooms").document(chatRoomDetail!.docID).collection("chat").order(by: "date").addSnapshotListener { snapShot, error in
            
            if error != nil {
                
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                self.messages = []
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    
                    //textを受信するMethod
                    if let text = data["text"] as? String, let senderID = data["senderID"] as? String, let imageURLString = data["imageURLString"] as? String, let date = data["date"] as? Double {
                        
                        //me
                        if senderID == Auth.auth().currentUser?.uid {
                            
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
                            
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "", thumbnailURLString: "")
                            
                            self.messages.append(message)
                            
                        }else {
                            
                            self.otherUser = Sender(senderId: senderID, displayName: "")
                            
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .text(text), userImagePath: imageURLString, date: date, messageImageString: "", thumbnailURLString: "")
                            
                            self.messages.append(message)
                            
                        }
                        
                    }
                    
                    //画像添付の受信
                    if let senderID = data["senderID"] as? String, let imageURLString = data["imageURLString"] as? String, let date = data["date"] as? Double, let attachImageString = data["attachImageString"] as? String {
                        
                        
                        //senderが
                        if senderID == Auth.auth().currentUser!.uid {
                            
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
                            
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .photo(ImageMediaItem(imageURL: URL(string: attachImageString)!)), userImagePath: imageURLString, date: date, messageImageString: attachImageString, thumbnailURLString: "")
                            
                            self.messages.append(message)
                            
                        }else {
                            
                            self.otherUser = Sender(senderId: senderID, displayName: "")
                            
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .photo(ImageMediaItem(imageURL: URL(string: attachImageString)!)), userImagePath: imageURLString, date: date, messageImageString: attachImageString, thumbnailURLString: "")
                            
                            self.messages.append(message)
                            
                        }
                        
                    }
                    
                    
                    
                    //動画添付の受信
                    if let senderID = data["senderID"] as? String, let imageURLString = data["imageURLString"] as? String, let date = data["date"] as? Double, let attachVideoString = data["attachVideoString"] as? String, let thumbnailURLString = data["thumbnailURLString"] as? String {
                        
                        
                        //senderが
                        if senderID == Auth.auth().currentUser!.uid {
                            
                            self.currentUser = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
                            
                            let message = Message(sender: self.currentUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .video(ImageMediaItem(imageURL: URL(string: attachVideoString)!)), userImagePath: imageURLString, date: date, messageImageString: attachVideoString, thumbnailURLString: thumbnailURLString)
                            
                            self.messages.append(message)
                            
                        }else {
                            
                            self.otherUser = Sender(senderId: senderID, displayName: "")
                            
                            let message = Message(sender: self.otherUser, messageId: senderID, sentDate: Date(timeIntervalSince1970: date), kind: .video(ImageMediaItem(imageURL: URL(string: attachVideoString)!)), userImagePath: imageURLString, date: date, messageImageString: attachVideoString, thumbnailURLString: thumbnailURLString)
                            
                            self.messages.append(message)
                            
                        }
                        
                    }
                    
                }
                
            }
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem()
            
            
        }
        
    }
    
    //UIImageViewにimage or videoのどちらを表示するかのmethod
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        switch message.kind {
        
        case MessageKind.photo(_):
            
            imageView.sd_setImage(with: URL(string: messages[indexPath.section].messageImageString), completed: nil)
            
            
        case MessageKind.video(_):
            
            imageView.sd_setImage(with: URL(string: messages[indexPath.section].thumbnailURLString), completed: nil)
            
        default:
            break
        }
        
    }
    
    
    //profileImageがtap後、呼び出されるmethod
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        
        
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        
        zoomSystem(imageString: messages[indexPath.section].userImagePath, avatorOrNot: true)
        
        
    }
    
    
    //添付画像がtap後、呼ばれるmethod
    func didTapImage(in cell: MessageCollectionViewCell) {
        
        if let indexPath = messagesCollectionView.indexPath(for: cell)  {
            
            let message = messages[indexPath.section]
            
            switch message.kind {
            case .video(let videoItem):
                
                if let videoUrl = videoItem.url {
                    
                    let player = AVPlayer(url: videoUrl)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    
                    present(playerViewController, animated: true) {
                        
                        playerViewController.player!.play()
                    }
                    
                }
                
            case .photo(let photo):
                
                if messages[indexPath.section].messageImageString.isEmpty != true {
                    
                    zoomSystem(imageString: messages[indexPath.section].messageImageString, avatorOrNot: false)
                }
                
            default:
                break
            }
            
        }
        
    }
    
    //avatarView表示method
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.sd_setImage(with: URL(string: messages[indexPath.section].userImagePath), completed: nil)
    }
    
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 16
    }
    
    
    //自分か他人か色を変える
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? Util.setChatColor(me: true) : Util.setChatColor(me: false)
        
    }
    
    //吹き出し
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        
        return .bubbleTail(corner, .curved)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.imageView.alpha == 1.0{
            
            UIView.animate(withDuration: 0.2) {
                
                self.blackView.alpha = 0.0
                self.imageView.alpha = 0.0
                self.imageView.layer.zPosition = 1
                self.blackView.layer.zPosition = 1
                self.messagesCollectionView.layer.zPosition = 2
            } completion: { finish in
                
                self.blackView.removeFromSuperview()
                self.imageView.removeFromSuperview()
            }
            
        }
        
    }
    
    
    
    func zoomSystem(imageString:String,avatorOrNot:Bool){
            //画像を拡大
            messagesCollectionView.layer.zPosition = 1
            blackView.frame = view.bounds
            blackView.backgroundColor = .darkGray
            blackView.alpha = 0.0
        
            imageView.frame = CGRect(x: 0, y: view.frame.size.width/2, width: view.frame.size.width, height: view.frame.size.width)
            imageView.isUserInteractionEnabled = true
            imageView.alpha = 0.0
            imageView.layer.zPosition = 2
            blackView.layer.zPosition = 2

            if avatorOrNot == true{
                imageView.layer.cornerRadius = imageView.frame.width/2
            }else{
                imageView.layer.cornerRadius = 20
            }
            imageView.contentMode = .scaleToFill
            imageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.2) {
                
                self.blackView.alpha = 0.9
                self.imageView.alpha = 1.0
                
            } completion: { finish in
                
            }

            imageView.sd_setImage(with: URL(string: imageString), completed: nil)
            view.addSubview(blackView)
            view.addSubview(imageView)
        }
    
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        inputBar.sendButton.startAnimating()
        
        let sendDBModel = SendDBModel()
        
        inputBar.inputTextView.text = ""
        
        //messageSendMethod
        sendDBModel.sendMessage(senderID: Auth.auth().currentUser!.uid, text: text, displayName: userModel!.name, imageURLString: userModel!.imageURLString, docID: chatRoomDetail!.docID)
        
        
        inputBar.sendButton.stopAnimating()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    
}
