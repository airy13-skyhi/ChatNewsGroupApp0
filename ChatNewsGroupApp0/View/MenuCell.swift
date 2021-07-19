//
//  MenuCell.swift
//  ChatNewsGroupApp0
//
//  Created by Manabu Kuramochi on 2021/07/15.
//

import UIKit
import SDWebImage


class MenuCell: UITableViewCell {
    
    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    static let identifier = "MenuCell"
    
    static func nib() -> UINib {
        
        return UINib(nibName: "MenuCell", bundle: nil)
        
    }
    
    
    func configure(chatRoomDetail:ChatRoomDetail) {
        
        titleLabel.text = chatRoomDetail.roomName
        roomImageView.sd_setImage(with: URL(string: chatRoomDetail.roomImageString), completed: nil)
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        roomImageView.layer.cornerRadius = roomImageView.frame.width/2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
