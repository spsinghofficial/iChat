//
//  WelcomeViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-04-30.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
             print("register")
    }
    @IBAction func tapGestureClicked(_ sender: Any) {
             print("tap gesture")
    }
    
}
