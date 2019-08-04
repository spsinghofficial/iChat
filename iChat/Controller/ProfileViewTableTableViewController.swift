//
//  ProfileViewTableTableViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-14.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class ProfileViewTableTableViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callButtonOutlet: UIButton!
    @IBOutlet weak var msgButtonOutlet: UIButton!
    @IBOutlet weak var blockButtonOutlet: UIButton!
    
    var user: FUser?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        else{
            return 30
        }
    }
    @IBAction func calButtonPressed(_ sender: Any) {
    }
    
    @IBAction func chatButtonPressed(_ sender: Any) {
    }
    
    @IBAction func blockUserButtonPressed(_ sender: Any) {
        print("block button pressed")
        var currentBlockedUsers = FUser.currentUser()!.blockedUsers
        if currentBlockedUsers.contains(user!.objectId){
            let index = FUser.currentUser()!.blockedUsers.index(of: user!.objectId)!
            currentBlockedUsers.remove(at: index)
            
        }
        else{
            currentBlockedUsers.append(user!.objectId)
        }
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID : currentBlockedUsers]) { (error) in
            if error != nil{
                print("error occured\(error?.localizedDescription)")
                return
            }
            else{
                self.updateBlockStatus()
            }
        }
    }
    
    func setupUI(){
        if user != nil{
            self.title = "Profile"
            fullNameLabel.text = user?.fullname
            phoneLabel.text = user?.phoneNumber
            updateBlockStatus()
            imageFromData(pictureData: user!.avatar) { (image) in
                if(image != nil){
                    self.avatarImageView.image = image?.circleMasked
                }
            }
        }
    }
    func  updateBlockStatus(){
        if(user!.objectId != FUser.currentId()){
            blockButtonOutlet.isHidden = false
            msgButtonOutlet.isHidden = false
            callButtonOutlet.isHidden = false
        }
        else{
            blockButtonOutlet.isHidden = true
            msgButtonOutlet.isHidden = true
            callButtonOutlet.isHidden = true
        }
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId){
            blockButtonOutlet.setTitle("Unblock User", for: .normal)
        }
        else{
            blockButtonOutlet.setTitle("Block User", for: .normal)
        }
        
    }
}
