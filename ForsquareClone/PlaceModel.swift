//
//  PlaceModel.swift
//  ForsquareClone
//
//  Created by Berke Topcu on 7.11.2022.
//

import Foundation
import UIKit

//Bir Singleton yapısı kurduk. Oluşturduğumuz bu instance sayesinde her yerde bu verilere ulaşabileceğiz. Ama ekleme çıkarma düzenleme yapılmayacak. Global tanımlamaktansa daha güvenli bir hal.

class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {}
    
    
}
