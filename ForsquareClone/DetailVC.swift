//
//  DetailVC.swift
//  ForsquareClone
//
//  Created by Berke Topcu on 7.11.2022.
//

import UIKit
import MapKit
import Parse

class DetailVC: UIViewController,MKMapViewDelegate{
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailTypeLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var detailMapView: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailMapView.delegate = self
        
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!")
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.detailNameLabel.text = placeName
                        }
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.detailTypeLabel.text = placeType                        }
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.detailNameLabel.text = placeAtmosphere
                        }
                        //Latitude ve Longitude değerlerimizi string olarak aldık ve ardından double'a çevirip değişkenlere ilettik.
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        //Resmi data olarak alıp çevirecegiz.
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                //Hata yoksa dataya çevrilen image'i detailImageView'a verdik.
                                if error == nil {
                                    self.detailImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                        
                        //Maps
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detailMapView.setRegion(region, animated: true)
                        
                        //Annotation
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.detailNameLabel.text!
                        annotation.subtitle = self.detailTypeLabel.text!
                        self.detailMapView.addAnnotation(annotation)

                        
                    }
                    
                }
            }
            
        }
    }
    
    func makeAlert(titleInput:String,messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        //Tekrar kullanıcalak id
        let reuseId = "myAnnotation"
        
        //Bir pin oluşturduk ve bunun MKPinAnnotationView olduğunu belirttik
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        //Pin eklendi mi kontrolü
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //Bir baloncuk içerisinde ekstra bilgi gösterildi.
            pinView?.canShowCallout = true
            pinView?.tintColor = UIColor.black
            //Detail Button
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            //Oluşturulan buton baloncuğun sağında gösterildi.
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    

  
   
    //Pin'e tıklandıktan sonra çıkan information butonuna yaptırılmak istenenlerin yazıldığı fonksiyon.
       func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
           if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
               //istenilen konum tekrar oluşturuldu.
               let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
               //mevcut konum ile gidilecek konum arasında bağlantı kurmak için gerekli hazır fonksiyon
               CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                   //placemarks nil değilse kontrolü yapmak için if let yapısı kurduk.
                   //placemark objesini reverse geocode location ile alıp kullanabiliyoruz.
                   if let placemark = placemarks {
                       if placemark.count > 0 {
                           let newPlacemark = MKPlacemark(placemark: placemark[0])
                           //Navigasyonu açabilmek için bir tane MapItem tanımladık.
                           let item = MKMapItem(placemark: newPlacemark)
                           item.name = self.detailNameLabel.text!
                           //Bu mapItem'ın hangi modu kullanmasını istediğimizi söyledik DirectionModeDriving (Arabayla)
                           let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                           item.openInMaps(launchOptions: launchOptions)
                           
                           
                       }
                   }
                   
               }
           }
       }
   
}
