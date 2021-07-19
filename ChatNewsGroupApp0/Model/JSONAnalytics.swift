//
//  JSONAnalytics.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/19.
//



import Foundation
import SwiftyJSON
import Alamofire


protocol DoneCatchNewsProtocol {
    
    func doneCatchNews(newsContentsArray:[NewsContents])
}


class JSONAnalytics {

    
    var urlString = "https://newsapi.org/v2/top-headlines?country=jp&apiKey=7970b3b37b234916aaffefb50a2014e5&pageSize=100"
    var newsContentsArray = [NewsContents]()
    var doneCatchNewsProtocol:DoneCatchNewsProtocol?
    
    
    func start() {
        
        
        let encordeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        AF.request(encordeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            
            print(response)
            
            switch response.result {
            
            
            case .success:
                
                do {
                    
                    let json:JSON = try JSON(data: response.data!)
                    let totalResults = json["totalResults"].int
                    
                    for i in 0...totalResults! - 1 {
                        
                        if let author = json["articles"][i]["author"].string, let title = json["articles"][i]["title"].string, let url = json["articles"][i]["url"].string, let urlToImage = json["articles"][i]["urlToImage"].string, let publishedAt = json["articles"][i]["publishedAt"].string {
                            
                            
                            let newsContents = NewsContents(author: author, title: title, url: url, urlToImage: urlToImage, publisheAt: publishedAt)
                            
                            self.newsContentsArray.append(newsContents)
                            
                        }
                        
                    }
                    self.doneCatchNewsProtocol?.doneCatchNews(newsContentsArray: self.newsContentsArray)
                    
                    
                } catch {
                    
                    
                    
                    
                }
            
            
            default: break
            }
            
            
            
            
        }
        
    }
    
}




