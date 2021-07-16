//
//  LoadDBModel.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/15.
//

import Foundation
import Firebase


protocol GetRoomNameProtocol {
    
    func getRoomNameProtocol(chatRoomDetailArray:[ChatRoomDetail])
}

//受信Model
class LoadDBModel {
    
    
    let db = Firestore.firestore()
    var chatRoomDetailArray = [ChatRoomDetail]()
    var getRoomNameProtocol:GetRoomNameProtocol?
    
    func loadRoomData() {
        
        //document以下のデータを取得
        db.collection("Rooms").addSnapshotListener { snapShot, error in
            
            
            if error != nil {
                return
            }
            
            
            if let snapShotDoc = snapShot?.documents {
                
                self.chatRoomDetailArray = []
                
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    
                    if let roomName = data["roomName"] as? String, let roomImageString = data["roomImageString"] as? String, let roomDetail = data["roomDetail"] as? String, let date = data["date"] as? Double, let backgroundImage = data["backgroundImage"] as? String, let docID = doc.documentID as? String  {
                        
                        let chatRoomDetail = ChatRoomDetail(date: date, roomdetail: roomDetail, roomImageString: roomImageString, roomName: roomName, backgroundImage: backgroundImage, docID: docID)
                        
                        
                    }
                    
                    
                }
                
                
                self.getRoomNameProtocol?.getRoomNameProtocol(chatRoomDetailArray: <#T##[ChatRoomDetail]#>)
                
                
            }
            
            
            
        }
        
        
    }
    
    
}


