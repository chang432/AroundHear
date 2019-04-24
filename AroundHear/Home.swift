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



class Home: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var usersref: CollectionReference!
    var db: Firestore!
    //let db = Firestore.firestore()
    var center: CLLocation!
    var geoFirestore: GeoFirestore!
    var counts: Int!
    //var keys = [NSDictionary]()
    var keys: NSMutableDictionary = NSMutableDictionary()
    var userDistances: Array<User> = Array<User>()
    
    @IBOutlet weak var nameButton: UIButton!
    let myRefreshControl = UIRefreshControl()
    var lastlocation: CLLocation!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let color = UIColor(red: 95/255.0, green: 114/255.0, blue: 189/255.0, alpha: 1)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        myRefreshControl.addTarget(self, action: #selector(checkLocations), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

        //self.navigationController?.navigationBar.barTintColor = color
        
        db = Firestore.firestore()
        usersref = db.collection("users")
        geoFirestore = GeoFirestore(collectionRef: self.usersref)
        ref = Database.database().reference()
        
        
        checkLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationServices()
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
    
    @objc func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManger()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    @objc func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //mapView.showsUserLocation = true
            //centerUserInMap()
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
  
        let button = sender as! UIButton

        let name = button.titleLabel?.text
        var key: String!
        for item in self.userDistances{
            if item.name == name{
                key = item.key
            }
        }
    
        let detailsViewController = segue.destination as! UserDetailsViewController
        detailsViewController.nameBar.title = name
        detailsViewController.key = key

    }
 

}




extension Home: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        self.lastlocation = locations.last
        if let userid = Auth.auth().currentUser {
            
            //updating firebase with new location... maybe remove this?
            ref.child("users").child(userid.uid).child("coordenates").updateChildValues(["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude])
            
            //creating a geopoint for the new location
            //var loc = GeoPoint.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            //Updating the current users location in the firestore database
            self.geoFirestore.setLocation(geopoint: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), forDocumentWithID: userid.uid) { (error) in
                if (error != nil) {
                    print("An error occured")
                } else {
                    print("Saved location successfully!")
                    //center of the radious to search
                    self.center = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    //query the database
                    self.keys.removeAllObjects()
                    let circleQuery = self.geoFirestore.query(withCenter: self.center, radius: 50)
                    
                    _ = circleQuery.observeReady {

                        _ = circleQuery.observe(.documentEntered, with: { (key, location) in
                            print("The document with documentID '\(key)' ENTERED the search area and is at location '\(location)'")
                            
                            
                            self.keys.setValue(location as Any, forKey: key!)
                            self.userDistances.removeAll()
                            self.userDistances = self.userDistance(keys: self.keys)
                            self.tableView.reloadData()
                        


                        })
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell") as! UsersCell
        
        self.ref.child("users").child(userDistances[indexPath.row].key).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? "ble"
            self.userDistances[indexPath.row].name = username
            //cell.nameLabel.text = username
            cell.nameButton.titleLabel!.text = username
            cell.nameButton.setTitle(username, for: .normal)
            
            
        })
        
        
        //cell.nameLabel.text = userDistances[indexPath.row].key
        // intdistance = userDistances[indexPath.row].distance as Int
        let distance:String = String(format: "%.0f meters away", userDistances[indexPath.row].distance)
        cell.distanceLabel.text = distance
        
        
        return cell
    }
    
    func userDistance(keys: NSMutableDictionary) -> Array<User>{
        
        var userArray = Array<User>()
    
        for (key, value) in self.keys {
            let distanceInMeter = self.center.distance(from: value as! CLLocation)
            let user = User(key: key as! String, distance: distanceInMeter)
            userArray.append(user)
        }
        
        userArray.sort{
            $0.distance < $1.distance
        }
        
        return userArray
    }
    
    @objc func checkLocations() {
        
        
        if let userid = Auth.auth().currentUser {
            
            //updating firebase with new location... maybe remove this?
            ref.child("users").child(userid.uid).child("coordenates").updateChildValues(["latitude": self.lastlocation.coordinate.latitude, "longitude": self.lastlocation.coordinate.longitude])
            
            //creating a geopoint for the new location
            //var loc = GeoPoint.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            //Updating the current users location in the firestore database
            self.geoFirestore.setLocation(geopoint: GeoPoint(latitude: self.lastlocation.coordinate.latitude, longitude: self.lastlocation.coordinate.longitude), forDocumentWithID: userid.uid) { (error) in
                if (error != nil) {
                    print("An error occured")
                } else {
                    print("Saved location successfully!")
                    //center of the radious to search
                    self.center = CLLocation(latitude: self.lastlocation.coordinate.latitude, longitude: self.lastlocation.coordinate.longitude)
                    //query the database
                    self.keys.removeAllObjects()
                    let circleQuery = self.geoFirestore.query(withCenter: self.center, radius: 50)
                    
                    _ = circleQuery.observeReady {
                        
                        _ = circleQuery.observe(.documentEntered, with: { (key, location) in
                            print("The document with documentID '\(key)' ENTERED the search area and is at location '\(location)'")
                            
                            
                            self.keys.setValue(location as Any, forKey: key!)
                            self.userDistances.removeAll()
                            self.userDistances = self.userDistance(keys: self.keys)
                            self.tableView.reloadData()
                            self.myRefreshControl.endRefreshing()
                            
                            
                        })
                    }
                }
            }
        }
        
    }
}


