//
//  AddPlacesVC.swift
//  ForsquareClone
//
//  Created by Berke Topcu on 6.11.2022.
//

import UIKit

class AddPlacesVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var placesNameField: UITextField!
    @IBOutlet weak var placesTypeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardClosed))
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        
        imageView.addGestureRecognizer(imageGestureRecognizer)
        view.addGestureRecognizer(gestureRecognizer)
    }
    

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        //inputlar boş mu kontrolü yaptıktan sonra son olarak image kontrolü yaptık ve instance'ımızı çağırıp oluşturduğumuz objeleri kullanıyoruz.
        if placesNameField.text != "" && placesTypeField.text != "" && descriptionField.text != "" {
            if let chosenImage = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placesNameField.text!
                placeModel.placeType = placesTypeField.text!
                placeModel.placeAtmosphere = descriptionField.text!
                placeModel.placeImage = chosenImage
                
            }
            performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            //Eğer inputlar boş ise ve next button'a basıldıysa kullanıcıza bir alert gösteriyoruz.
            let alert = UIAlertController(title: "Error", message: "Place Name/Type/Description?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true,completion: nil)
        }
        
       
        
    }
    
    
    @objc func keyboardClosed() {
        view.endEditing(true)
    }
    
    @objc func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        nextButton.isEnabled = true
        self.dismiss(animated: true,completion: nil)
    }
}
