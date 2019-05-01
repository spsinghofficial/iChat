//
//  RegisterViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-01.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    var email: String!
    var password: String!
    var profileImage : UIImage?
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
   
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email)
        print(password)

    }

    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
}
