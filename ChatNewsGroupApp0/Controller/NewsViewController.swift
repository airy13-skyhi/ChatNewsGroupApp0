//
//  NewsViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/16.
//

import UIKit



class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneCatchNewsProtocol {
    

    
    var tableView = UITableView()
    var newsContentsArray = [NewsContents]()

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
        tableView.register(NewsCell.nib(), forCellReuseIdentifier: NewsCell.identifier)
        
        
        //addSubview 貼り付け
        view.addSubview(tableView)
        
        let jsonAnalytics = JSONAnalytics()
        jsonAnalytics.doneCatchNewsProtocol = self
        jsonAnalytics.start()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as! NewsCell
        cell.backgroundColor = .clear
        cell.configure(title: self.newsContentsArray[indexPath.row].title, publishedAt: self.newsContentsArray[indexPath.row].publisheAt, urlToImage: self.newsContentsArray[indexPath.row].urlToImage)
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsContentsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func doneCatchNews(newsContentsArray: [NewsContents]) {
        
        self.newsContentsArray = newsContentsArray
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "webVC", sender: indexPath.row)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let webVC = segue.destination as! WebViewController
        webVC.urlString = self.newsContentsArray[sender as! Int].url
        webVC.authorTitle = self.newsContentsArray[sender as! Int].author
        
    }
    
    
    

}
