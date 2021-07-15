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
    
    
    
    
}

