//
//  UserTableViewCell.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-10.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//
protocol UserTableViewCellDelegate {
    func didTapAvatarimage(indexPath: IndexPath)
}
import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    var indexPath : IndexPath!
    var delegate: UserTableViewCellDelegate?
    let tapGestureRecogniser = UITapGestureRecognizer()
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureRecogniser.addTarget(self, action: #selector(self.avatartap))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecogniser)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func generateCellWith(fuser: FUser, indexPath: IndexPath){
        self.fullNameLabel.text = fuser.fullname
        self.indexPath = indexPath
        imageFromData(pictureData: fuser.avatar) { (avatarImage) in
            if(avatarImage != nil){
                self.profileImageView.image = avatarImage?.circleMasked
            }
        }
        
        
    }
   @objc func avatartap(){
        delegate!.didTapAvatarimage(indexPath: indexPath)
    }

}
