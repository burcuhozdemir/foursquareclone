//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Burcu on 5.10.2021.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    //next button clicked
    @IBAction func nextButtonCliced(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && atmosphereText.text != ""{
            if let choosenImage = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placaType = placeTypeText.text!
                placeModel.placeAtmosphere  = atmosphereText.text!
                placeModel.placeImage = choosenImage
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Place name, type, atmoshere are required!", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    //choose image
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}
