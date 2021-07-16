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


protocol GetUserData {
    
    func getUserData(userModel:UserModel)
    
}


//受信Model
class LoadDBModel {
    
    
    let db = Firestore.firestore()
    var chatRoomDetailArray = [ChatRoomDetail]()
    var getRoomNameProtocol:GetRoomNameProtocol?
    var getUserData:GetUserData?
    
    
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
                        
                        
                        self.chatRoomDetailArray.append(chatRoomDetail)
                    }
                    
                    
                }
                
                
                self.getRoomNameProtocol?.getRoomNameProtocol(chatRoomDetailArray: self.chatRoomDetailArray)
                
                
            }
            
        }
        
    }
    
    //My Profileを受信
    func loadProfileData() {
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).addSnapshotListener { snapShot, error in
            
            
            if error != nil {
                return
            }
            
            let data = snapShot?.data()
            let userModel = UserModel(name: data!["userName"] as! String, uid: data!["uid"] as! String, imageURLString: data!["imageURLString"] as! String, date: data!["date"] as! Double)
            
            
            self.getUserData?.getUserData(userModel: userModel)
        }
        
    }
    
}


