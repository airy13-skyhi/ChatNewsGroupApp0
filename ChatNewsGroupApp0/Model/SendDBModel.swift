//
//  SendDBModel.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import Foundation
import Firebase


protocol DoneCreateRoom {
    
    func doneCreateRoom()
    
}


//送信Model
class SendDBModel {
    
    let db = Firestore.firestore()
    var doneCreateRoom:DoneCreateRoom?
    
    
    
    func createNewUser(profileImageData:Data, name:String, uid:String) {
        
        
        //データの送信先をstorageに指定 Storage
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        
        //画像の情報をstorageにputする putData
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            
            if error != nil {
                return
            }
            
            //putDataした画像のurlを取得する downloadURL
            imageRef.downloadURL { url, error in
                
                if error != nil {
                    return
                }
                
                if url != nil {
                    
                    //dbへ指定した情報を送信　setData
                    self.db.collection("Users").document(uid).setData(["name":name, "uid":uid, "imageURLString":url?.absoluteString, "date":Date().timeIntervalSince1970])
                }
                
                
            }
            
        }
        
    }
    
    
    //NewRoomのcoll,doc,data階層の中身を構築
    func createNewRoom(roomName:String, roomDetail:String, roomImage:Data, backgroundImageData:Data) {
        
        //データの送信先をstorageに指定 Storage
        let imageRefRoom = Storage.storage().reference().child("RoomIamge").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        let imageRefRoomBack = Storage.storage().reference().child("RoomBackImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        
        imageRefRoom.putData(roomImage, metadata: nil) { metaData, error in
            
            
            if error != nil {
                return
            }
            
            imageRefRoom.downloadURL { urlRooom, error in
                
                if error != nil {
                    return
                }
                
                imageRefRoomBack.putData(backgroundImageData, metadata: nil) { metaData, error in
                    
                    if error != nil {
                        return
                    }
                    
                    imageRefRoomBack.downloadURL { urlRoomBack, error in
                        
                        if error != nil {
                            return
                        }
                        
                        //送信 NewRoomのDataを作成
                        if urlRoomBack != nil {
                            
                            
                            self.db.collection("Rooms").document().setData(
                                
                                ["roomName":roomName, "roomDetail":roomDetail, "roomImageString":urlRooom?.absoluteString, "backgroundImage":urlRoomBack?.absoluteString, "date":Date().timeIntervalSince1970])
                        }
                        
                        self.doneCreateRoom?.doneCreateRoom()
                    }
                    
                    
                }
                
            }
            
        }
        
    }
    
    
    func sendMessage(senderID:String, text:String, displayName:String, imageURLString:String, docID:String) {
        
        
        self.db.collection("Rooms").document("docID").collection("chat").document().setData(
            
            ["text":text as Any, "senderID":senderID as Any, "displayName":displayName as Any, "imageURLString":imageURLString as Any, "date":Date().timeIntervalSince1970]
        
        )
        
        
    }
    
    
    func sendImageData(image:UIImage, senderID:String, userModel:UserModel, docID:String) {
        
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metadata, error in
            
            
            if error != nil {
                return
            }
            
            imageRef.downloadURL { url, error in
                
                if error != nil {
                    return
                }
                
                
                if url != nil {
                    
                    self.db.collection("Rooms").document(docID).collection("chat").document().setData(
                    
                        ["senderID":Auth.auth().currentUser!.uid, "imageURLStrng":userModel.imageURLString, "displayName":userModel.name, "date":Date().timeIntervalSince1970, "attachImageString":url?.absoluteString as Any]
                    
                    )
                    
                }
        
            }
            
        }
        
    }
    
    
    func sendVideoData(videoURL:URL, senderID:String, userModel:UserModel, docID:String, thumbnail:String) {
        
        let videoRef = Storage.storage().reference().child("Videos").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).mp4")
        
        let metadata = StorageMetadata()
        metadata.contentType = "video/quickTime"
        
        if let videoData = NSData(contentsOf: videoURL) as Data? {
            
            videoRef.putData(videoData, metadata: nil) { metadata, error in
                
                if error != nil {
                    return
                }
                
                videoRef.downloadURL { url, error in
                    
                    if url != nil {
                        
                        self.db.collection("Rooms").document(docID).collection("chat").document().setData(
                        
                            ["senderID":Auth.auth().currentUser!.uid, "imageURLString":userModel.imageURLString, "displayName":userModel.name as Any, "date":Date().timeIntervalSince1970, "attachVideoString":url!.absoluteString, "thumbnailURLString":thumbnail]
                            
                        )
                    }
                }
                
                
                
                
            }
        }
        
        
    }
    
    
    
}

