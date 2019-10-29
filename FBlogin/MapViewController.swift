//
//  MapViewController.swift
//  FBlogin
//
//  Created by Roxanne Zhang on 10/27/19.
//  Copyright © 2019 Roxanne Zhang. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  var profilePhoto: UIImage?
  var imagePicker = UIImagePickerController()
  let location = Location()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    location.getCurrentLocation()
    let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
    centerMapOnLocation(location: initialLocation)
    // drop pin annotation
    mapView.delegate = self
    let droppedPin = MKPointAnnotation()
    droppedPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    droppedPin.title = "You Are Here"
    droppedPin.subtitle = "Look it's you!"
    mapView.addAnnotation(droppedPin)
  }
  
  @IBAction func displayActionSheet(_ sender: Any) {
      let optionMenu = UIAlertController(title: nil, message: "Choose Meme Image", preferredStyle: .actionSheet)
    
      let cameraAction = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert:UIAlertAction!) -> Void in
          self.openCamera()
      })
      let albumAction = UIAlertAction(title: "Choose from Album", style: .default, handler: { (alert:UIAlertAction!) -> Void in
        self.openGallery()
      })
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
      optionMenu.addAction(cameraAction)
      optionMenu.addAction(albumAction)
      optionMenu.addAction(cancelAction)
          
      self.present(optionMenu, animated: true, completion: nil)
  }
  
  func openCamera()
  {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
      {
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
          imagePicker.allowsEditing = true
        imagePicker.delegate = self
          self.present(imagePicker, animated: true, completion: nil)
      }
      else
      {
          let alert  = UIAlertController(title: "Warning", message: "You don't have camera. Camera is not available in simulators.", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
          self.present(alert, animated: true, completion: nil)
      }
  }

  func openGallery()
  {
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
      imagePicker.allowsEditing = true
    imagePicker.delegate = self
      self.present(imagePicker, animated: true, completion: nil)
  }
  
  let regionRadius: CLLocationDistance = 400
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  // customize drop pin - use profilePhoto
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") //as? MKPinAnnotationView
    if pinView == nil {
      pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
    }
    if let profilePic = profilePhoto {
      pinView!.image = profilePic
    }
    pinView!.canShowCallout = true
    return pinView
  }
}

extension MapViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
