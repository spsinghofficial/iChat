//
//  RegisterViewController.swift
//  iChat
//
//  Created by surinder pal singh sidhu on 2019-05-01.
//  Copyright © 2019 surinder pal singh sidhu. All rights reserved.
//

import UIKit
import ProgressHUD

class RegisterViewController: UIViewController {
    var email: String!
    var password: String!
    var profileImage : UIImage?
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
   
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

    }

    @IBAction func doneButtonPressed(_ sender: Any) {
        ProgressHUD.show()
        if(nameTextField.text != "" && surnameTextField.text != "" && cityTextField.text != "" && phoneTextField.text != ""){
            FUser.registerUserWith(email: email, password: password, firstName: nameTextField.text!, lastName: surnameTextField.text!) { (error) in
                if (error != nil){
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                else{
                    self.registerUser()
                }
            }
            
        }
        else{
            ProgressHUD.dismiss()
            ProgressHUD.showError("all fields are mandatory")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: HELPER FUNCTIONS
    
    func registerUser(){
      let fullName = nameTextField.text! + " " + surnameTextField.text!
        var tempDictionary : Dictionary = [
            kFIRSTNAME: nameTextField.text!,
            kLASTNAME : surnameTextField.text!,
            kFULLNAME : fullName,
            kCOUNTRY : countryTextField.text!,
            kCITY : cityTextField.text!,
            kPHONE : phoneTextField.text!
        ] as [String: Any]
        
        if (profileImage == nil){
            imageFromInitials(firstName: nameTextField.text!, lastName: surnameTextField.text!) { (image) in
                let imageData = image.jpegData(compressionQuality: 0.7)
                let imageUrl = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                tempDictionary[kAVATAR] = imageUrl
                  self.finishRegistration(value: tempDictionary)
            }
        }
        else{
            let imageData = profileImage?.jpegData(compressionQuality: 0.7)
            let imageUrl = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            tempDictionary[kAVATAR] = imageUrl
            self.finishRegistration(value: tempDictionary)
        }
    }
    
    func finishRegistration(value: Dictionary<String, Any>){
        updateCurrentUserInFirestore(withValues: value) { (error) in
            if(error != nil){
                DispatchQueue.main.async {
                    ProgressHUD.showError(error?.localizedDescription)
                }
                return
            }
            else{
               // goto profile
                ProgressHUD.dismiss()
                self.goToMainView()
                
            }
        }
    }
    
    func goToMainView(){
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC") as! UITabBarController
        self.present(mainView, animated: true, completion: nil)
    }
    func dismissKeyBoard(){
        self.view.endEditing(false)
    }
    
    @IBAction func tapGestureClicked(_ sender: Any) {
        dismissKeyBoard()
    }
}
