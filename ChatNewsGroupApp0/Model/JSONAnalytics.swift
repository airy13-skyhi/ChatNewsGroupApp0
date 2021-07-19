//
//  JSONAnalytics.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/19.
//




import Foundation
import SwiftyJSON
import Alamofire


class JSONAnalytics {

    
    var urlString = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=7970b3b37b234916aaffefb50a2014e5&pageSize=100"
    
    
    
    func start() {
        
        
        let encordeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
    }
    
}




