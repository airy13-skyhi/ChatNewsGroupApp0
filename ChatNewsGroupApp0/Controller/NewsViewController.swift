//
//  NewsViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/16.
//

import UIKit



class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //user有
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "newsBack")
        view.addSubview(imageView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .clear
        tableView.register(MenuCell.nib(), forCellReuseIdentifier: MenuCell.identifier)
        
        
        //addSubview 貼り付け
        view.addSubview(tableView)

        
    }
    

    

}
