//
//  NewsCell.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/16.
//

import UIKit
import SDWebImage


class NewsCell: UITableViewCell {
    
    
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    
    
    static let identifier = "NewsCell"
    
    static func nib() -> UINib {
        
        return UINib(nibName: "NewsCell", bundle: nil)
        
    }
    
    
    //
    func configure(title:String, publishedAt:String, urlToImage:String) {
        
        titleLabel.text = title
        publishedAtLabel.text = publishedAt
        newsImageView.sd_setImage(with: URL(string: urlToImage), completed: nil)
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        newsImageView.layer.cornerRadius = newsImageView.frame.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
