//
//  CreateNewRoomViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/14.
//

import UIKit



class CreateNewRoomViewController: CreateNewUserController, DoneCreateRoom {
    
    
    var imageFlag = false
    
    
    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomDetailTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var roomCreateButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        
        Util.rectButton(button: backgroundButton)
        Util.rectButton(button: roomCreateButton)
        
        roomImageView.layer.cornerRadius = roomImageView.frame.width/2
    }
    
    
    @IBAction func tap(_ sender: Any) {
        
        imageFlag = false
        openCamera()
        
    }
    
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if imageFlag == false {
            
            if let pickedImage = info[.editedImage] as? UIImage {
                
                //選択画像の表示
                roomImageView.image = pickedImage
                imageFlag = true
                picker.dismiss(animated: true, completion: nil)
                
            }
            
            
        }else if imageFlag == true {
            
            if let pickedImage = info[.editedImage] as? UIImage {
                
                //選択画像の表示
                backgroundImageView.image = pickedImage
                imageFlag = false
                picker.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func setBackgroundImage(_ sender: Any) {
        
        imageFlag = true
        openCamera()
        
    }
    
    
    
    @IBAction func createAction(_ sender: Any) {
        
        
        //roomCreate Method
        sendDBModel.doneCreateRoom = self
        sendDBModel.createNewRoom(roomName: roomNameTextField.text!, roomDetail: roomDetailTextView.text!, roomImage: (roomImageView.image?.jpegData(compressionQuality: 0.3))!, backgroundImageData: (backgroundImageView.image?.jpegData(compressionQuality: 0.3))!)
        
        
    }
    
    
    
    func doneCreateRoom() {
        
        
        self.tabBarController?.selectedIndex = 0
        roomImageView.image = UIImage(named: "home")
        roomNameTextField.text = ""
        roomDetailTextView.text = ""
        
    }
    
    
    
    
}
