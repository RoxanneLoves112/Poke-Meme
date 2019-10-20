//
//  ViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 10/20/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
  
  @IBOutlet var lblStatus: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let btnFBLogin = FBLoginButton()
    btnFBLogin.permissions = ["public_profile", "email"]
    btnFBLogin.delegate = self
    btnFBLogin.center = view.center
    view.addSubview(btnFBLogin)
    
    if AccessToken.current != nil{
      self.lblStatus.text = "User previously logged in"
    } else{
      self.lblStatus.text = "User not logged in"
    }
  }
  
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    if error != nil{
      self.lblStatus.text = error?.localizedDescription
    } else if result!.isCancelled {
      self.lblStatus.text = "Login was cancelled"
    } else{
      //successful login
      self.lblStatus.text = "User successfully logged in"
    }
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    self.lblStatus.text = "User logged out"
  }

}

