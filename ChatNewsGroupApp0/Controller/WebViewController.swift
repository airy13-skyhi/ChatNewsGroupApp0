//
//  WebViewController.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/19.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    
    var urlString = String()
    var authorTitle = String()
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        webView.load(request)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        title = authorTitle
        
        
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        webView.goBack()
    }
    
    
    
    @IBAction func forward(_ sender: Any) {
        
        webView.goForward()
    }
    
    
    
    
}
