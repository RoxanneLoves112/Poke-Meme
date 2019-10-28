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
  
  var profilePhoto: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = true;
    let btnFBLogin = FBLoginButton()
    btnFBLogin.permissions = ["public_profile", "email"]
    btnFBLogin.delegate = self
    btnFBLogin.center = CGPoint(x: view.center.x, y: view.center.y + 200);
    view.addSubview(btnFBLogin)
    
    if let token = AccessToken.current {
      print("already logged in ")
      let currentUserID = token.userID
      fetchProfile(userID: currentUserID)
      self.performSegue(withIdentifier: "toMapView", sender: self)
    } else{
      print("logged out")
    }
  }
  
  func fetchProfile(userID: String){
    print("fetching profile")
    let fbProfileUrl = URL(string:"http://graph.facebook.com/\(userID)/picture?type=large")
    if let data = try? Data(contentsOf: fbProfileUrl!)
    {
      profilePhoto = UIImage(data: data)
      print("successfully fetched profile")
    } else{
      print("error when fetching profile")
    }
  }
  
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    if error != nil{
      print("error occurred during login")
    } else if result!.isCancelled {
      print("login cancelled")
    } else{
      print("successful login")
      self.performSegue(withIdentifier: "toMapView", sender: self)
      // should set mapViewController to the root controller if logged in
    }
  }

  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
  }
  
  // pass profile photo to map view Controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let mapViewController = segue.destination as? MapViewController,
      let image = profilePhoto
      else {
        return
    }
    mapViewController.profilePhoto = resizeImage(image: image, newWidth: 50)
  }
  
  // resize image without losing quality
  func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil}
    UIGraphicsEndImageContext()
    return newImage
  }
}

