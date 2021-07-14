//
//  CreateNewRoomViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/14.
//

import UIKit



class CreateNewRoomViewController: UIViewController {
    
    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomDetailTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Util.rectButton(button: backgroundButton)
        Util.rectButton(button: createButton)
        
        roomImageView.layer.cornerRadius = roomImageView.frame.width/2
    }
    

    
    
    

}
