//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Burcu on 5.10.2021.
//

import Foundation
import UIKit

//singleton
class PlaceModel{
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placaType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
    
}
