//
//  ViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/13.
//

import UIKit
import Firebase

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //もしユーザー有　そのまま、無　createNewUserVCへ画面遷移
        
        
        if Auth.auth().currentUser?.uid != nil {
            //user有
            let imageView = UIImageView(frame: view.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: "top")
            view.addSubview(imageView)
            
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            tableView.backgroundColor = .clear
            
            //addSubview 貼り付け
            view.addSubview(tableView)
            
        }else {
            //user無
            
            performSegue(withIdentifier: "createNewUserVC", sender: nil)
            
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    
}

