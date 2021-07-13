//
//  SendDBModel.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import Foundation
import Firebase

class SendDBModel {
    
    let db = Firestore.firestore()
    
    
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
    
    
}

