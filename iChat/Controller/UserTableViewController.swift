//
//  UserTableViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-10.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class UserTableViewController: UITableViewController, UISearchResultsUpdating,UserTableViewCellDelegate {
   
   

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var allUser: [FUser] = []
    var filteredUsers:[FUser] = []
    var allUsersGrouped =  NSDictionary() as! [String : [FUser]]
    var sectionTitle : [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
         loadUsers(filter: kCITY)
        self.title = "Users"
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
       

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        if(searchController.isActive && searchController.searchBar.text != ""){
            return 1
        }
        else{
            return allUsersGrouped.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(searchController.isActive && searchController.searchBar.text != ""){
            return filteredUsers.count
        }
        else{
            // find section title
            let sectionTitle = self.sectionTitle[section]
            
            // find user at that section
            
            let users = self.allUsersGrouped[sectionTitle]
            return users!.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usertablecell", for: indexPath) as! UserTableViewCell
        var user: FUser
        if(searchController.isActive && searchController.searchBar.text != ""){
           user = filteredUsers[indexPath.row]
        }
        else{
          
          let sectiontitle = sectionTitle[indexPath.section]
            var users = allUsersGrouped[sectiontitle]
            user = users![indexPath.row]
            
          
            
        }
        cell.generateCellWith(fuser:user, indexPath: indexPath)
       cell.delegate = self

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var user: FUser
        if(searchController.isActive && searchController.searchBar.text != ""){
            user = filteredUsers[indexPath.row]
        }
        else{
            
            let sectiontitle = sectionTitle[indexPath.section]
            var users = allUsersGrouped[sectiontitle]
            user = users![indexPath.row]
            
            
            
        }
        startPrivateChat(user1: FUser.currentUser()!, user2: user)
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(searchController.isActive && searchController.searchBar.text != ""){
           return ""
        }
        else{
            return sectionTitle[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if(searchController.isActive && searchController.searchBar.text != ""){
            return nil
        }
        else{
            return self.sectionTitle
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    func loadUsers(filter: String){
        ProgressHUD.show()
        var query : Query!
        
        switch filter {
        case kCITY:
            query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()?.city).order(by: kFIRSTNAME
                , descending: false)
        case  kCOUNTRY:
            query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()?.country).order(by:kFIRSTNAME, descending: false)
        default:
            query = reference(.User).order(by: kFIRSTNAME, descending: false)
        }
        query.getDocuments { (snapshot, error) in
            self.allUser = []
            self.filteredUsers = []
            self.allUsersGrouped = [:]
            if error != nil{
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            guard let snapshot = snapshot else{
                ProgressHUD.dismiss()
                return
            }
            
            if !snapshot.isEmpty{
                for userDictionary in snapshot.documents{
                    let userDictionary = userDictionary.data() as! NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    if fUser.objectId != FUser.currentId() {
                        self.allUser.append(fUser)
                       
                    }
                }
                // split to groups
                self.splitIntoSection()
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
            ProgressHUD.dismiss()
        }
    
    }
    func searchUserWithtext(searchText: String, scope: String = "All") {
        filteredUsers = allUser.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchUserWithtext(searchText: searchController.searchBar.text!)
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
            
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
            
        default:
            return
        }
    }
    fileprivate func splitIntoSection(){
        var sectionTitle = ""
        for i in 0..<self.allUser.count{
            let currentUser = allUser[i]
            let firstChar = currentUser.firstname.first!
            let firstCharString = "\(firstChar)"
            if firstCharString != sectionTitle{
                sectionTitle = firstCharString
                self.allUsersGrouped[sectionTitle] = []
                self.sectionTitle.append(sectionTitle)
            }
            self.allUsersGrouped[firstCharString]?.append(currentUser)
       
        }
    }
    
    func didTapAvatarimage(indexPath: IndexPath) {
       let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileView") as! ProfileViewTableTableViewController
        var user: FUser
        if(searchController.isActive && searchController.searchBar.text != ""){
            user = filteredUsers[indexPath.row]
        }
        else{
            
            let sectiontitle = sectionTitle[indexPath.section]
            var users = allUsersGrouped[sectiontitle]
            user = users![indexPath.row]
            
            
            
        }
        profileVC.user = user
        
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
}
