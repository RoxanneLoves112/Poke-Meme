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
//    mapView(mapView, viewFor: droppedPin)
    mapView.addAnnotation(droppedPin)
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


