//
//  Home.swift
//  AroundHear
//
//  Created by Guillermo on 3/28/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase
import Geofirestore



class Home: UIViewController {
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var ref: DatabaseReference!
    var usersref: CollectionReference!
    var db: Firestore!
    //let db = Firestore.firestore()
    var center: CLLocation!
    var geoFirestore: GeoFirestore!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        usersref = db.collection("users")
        geoFirestore = GeoFirestore(collectionRef: self.usersref)
        ref = Database.database().reference()
        
        
        checkLocationServices()
    }
    
    func centerUserInMap() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region, animated: true)

        }
    }
    
    func setUpLocationManger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManger()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerUserInMap()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            break
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Home: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
//        print(location.coordinate.latitude, location.coordinate.longitude)
//        let coordenate1 = CLLocation(latitude: 51.58, longitude: -0.12)
//        let distance = coordenate1.distance(from: location)
//        print(distance)
        
        
        if let userid = Auth.auth().currentUser {
            ref.child("users").child(userid.uid).child("coordenates").updateChildValues(["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
            
            
            var loc = GeoPoint.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            let data: [String: Any] = [
//                "loc": loc
//
//            ]
            
            self.geoFirestore.setLocation(geopoint: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), forDocumentWithID: userid.uid) { (error) in
                if (error != nil) {
                    print("An error occured: \(error)")
                } else {
                    print("Saved location successfully!")
                    self.center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let circleQuery = self.geoFirestore.query(withCenter: self.center, radius: 0.6)
                    var locationsPin = [MKPointAnnotation]()

                    circleQuery.observeReady {
                        print("FUCKING READYYYYYYY")
                        circleQuery.observe(.documentEntered, with: { (key, location) in
                            print("The document with documentID '\(key)' ENTERED the search area and is at location '\(location)'")
                            
//                            let dropPin = MKPointAnnotation()
//                            let coor = location?.coordinate
//
//                            if coor != nil{
//                                dropPin.coordinate = coor!
//                            }
//                            self.mapView.addAnnotation(dropPin)
//                            //self.mapView.selectAnnotation(dropPin, animated: true)
//                            locationsPin.append(dropPin)
//                            //self.mapView.showAnnotations(locationsPin, animated: true)
                        })
                        
                        let queryHandle2 = circleQuery.observe(.documentExited, with: { (key, location) in
                            print("The document with documentID '\(key)' EXITED the search area and is at location '\(location)'")
                            
                    
                            
                        })
                        
                        
                    }

                
                    
                }
            }
            
            
            
            //self.db.collection("users").document(userid.uid).setData
        }
        

        
        
        
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

