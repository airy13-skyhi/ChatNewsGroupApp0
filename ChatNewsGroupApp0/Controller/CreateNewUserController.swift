//
//  CreateNewUserController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import UIKit
import Firebase



class CreateNewUserController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        //ボタンレイアウトmethod
        Util.rectButton(button: createButton)
        
    }
    
    
    @IBAction func tapImageView(_ sender: Any) {
        
        //カメラ起動
        openCamera()
        
        
    }
    
    
    
    func openCamera(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            present(cameraPicker, animated: true, completion: nil)
            
        }else{
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[.editedImage] as? UIImage
        {
            profileImageView.image = pickedImage
            //閉じる処理
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createNewUser(_ sender: Any) {
        
        let sendDBModel = SendDBModel()
        
        Auth.auth().signInAnonymously { result, error in
            
            //送信内容の最終調整後、送信完了
            sendDBModel.createNewUser(profileImageData: (self.profileImageView.image?.jpegData(compressionQuality: 0.3))!, name: self.nameTextField.text!, uid: Auth.auth().currentUser!.uid)
         
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
}
