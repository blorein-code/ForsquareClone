//
//  MapVC.swift
//  ForsquareClone
//
//  Created by Berke Topcu on 6.11.2022.
//

import UIKit
import MapKit
import Parse


class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //NavBar Buttons created.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveClicked))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.done, target: self, action: #selector(backClicked))
        
        //Maps
        mapView.delegate = self
        locationManager.delegate = self
        //Konum doğruluk oranlarını belirttik. Konum işlemleri için Authorization aldık. Konum alınmaya başlandı.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //Map Pin için GestureRecognizer
        let pinGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapPinned))
        mapView.addGestureRecognizer(pinGestureRecognizer)
        //Bastıktan kaç saniye sonra işlem yapılacağını belirledik.
        pinGestureRecognizer.minimumPressDuration = 2
        mapView.isUserInteractionEnabled = true
        
    }
    
    
    //Kullanıcının enlem ve boylamına göre konumu alındı.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Lokasyon işlemleri için enlem ve boylam özelliklerini kullandık.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        // zoom seviyesini belirledik
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        //Kullanıcının mevcut konumunu belirlemek için kullanıcıdan aldığımız location bilgilerini kullanıp bunları mapview üzerinde gösterdik.
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    //Kullanıcının konum işaretledikten sonra yeni açılacak butona basarak mevcut konumundan buraya yol tarifi alması sağlandı.
    
 
    
    
    
    
    
    @objc func mapPinned(gestureRecognizer:UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            //Tıklandığı noktayı işaretlemek için
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            //Latitude ve Longitude
            PlaceModel.sharedInstance.placeLatitude = String(touchedCoordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(touchedCoordinates.longitude)
            // Pin oluşturuldu.
            let annotation = MKPointAnnotation()
            //Oluşturulan pin belirlenen noktaya eklendi.
            annotation.coordinate = touchedCoordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
        }
    }
    
    @objc func saveClicked() {
        //DB'ye kaydedip artından tableview a dönüş yapılacak ve veriler table view'a iletilecek.
        let placeModel = PlaceModel.sharedInstance
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        let uuidString = UUID().uuidString
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "\(uuidString).jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Error!", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
   
    @objc func backClicked() {
        self.dismiss(animated: true,completion: nil)
    }
    
    

}
