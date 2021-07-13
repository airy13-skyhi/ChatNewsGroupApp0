//
//  ViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import UIKit
import Firebase

class RoomViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //もしユーザー有　そのまま、無　createNewUserVCへ画面遷移
        
        
        if Auth.auth().currentUser?.uid != nil {
            
            //user有
            
            
        }else {
            
            //user無
            
            performSegue(withIdentifier: "createNewUserVC", sender: nil)
            
        }
        
        
        
    }


}

