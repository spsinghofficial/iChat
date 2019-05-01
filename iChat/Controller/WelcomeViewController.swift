//
//  WelcomeViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-04-30.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != ""){
           loginUser()
        }
        else{
          ProgressHUD.showError("Email and password are required")
        }
        dismissKeyBoard()
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != ""  && repeatPasswordTextField.text != "" ){
            registerUser()
        }
        else{
            ProgressHUD.showError("All fields are required")
        }
    
        dismissKeyBoard()
    }
    @IBAction func tapGestureClicked(_ sender: Any) {
        
        dismissKeyBoard()
    }
    
    func dismissKeyBoard(){
        self.view.endEditing(false)
    }
    
    func clearTextField(){
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    func loginUser(){
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
              ProgressHUD.showError(error!.localizedDescription)
                return
            }
            else{
                // present the app
            }
        }
    }
    
    func registerUser(){
      performSegue(withIdentifier: "goToRegisterVC", sender: self)
      clearTextField()
      dismissKeyBoard()
        
      
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRegisterVC") {
            let vc = segue.destination as! RegisterViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
        }
    }
    
}
