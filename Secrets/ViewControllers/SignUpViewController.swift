//
//  SignUpViewController.swift
//  Secrets
//
//  Created by James Craige on 4/10/15.
//  Copyright (c) 2015 thoughtbot. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: AuthenticationViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUp(sender: UIButton?) {
        signUp()
    }
    
    func signUp() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        let onError = { (error: NSError) -> Int in
            let errorMessage = error.userInfo?["error"] as? String
            self.alertWithTitle("Error", message: errorMessage)
            return 1
        }
        
        UserAuthenticator.signUp(email, password: password).then { (user: PFUser) in
            self.presentMainFlow()
        }.catch(onQueue: dispatch_get_main_queue(), body: onError)
        
//        UserAuthenticator.signUp(email, password: password).then { (user: PFUser) -> Void in
//            self.presentMainFlow()
//            return;
//        }.catch { (error: NSError) -> Void in
//            let errorMessage = result.error?.userInfo?["error"] as? String
//            self.alertWithTitle("Error", message: errorMessage)
//            return;
//        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: signUp()
        default: break
        }
  
        return true
    }
}
