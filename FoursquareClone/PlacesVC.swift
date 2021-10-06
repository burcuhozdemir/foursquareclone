//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Burcu on 5.10.2021.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //add button
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        //logout button
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
        
    }
    
    //DATAS
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground{(objects, error) in
            if error != nil{
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                if objects != nil{
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    for object in objects!{
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId {
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //add button clicked
    @objc func addButtonClicked(){
        //segue
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    //logout button clicked
    @objc func logoutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            }else{
                self.performSegue(withIdentifier: "toSignupVC", sender: nil)
            }
        }
    }
    
    //tableView cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    //tableView row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    //segue to details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenPlaceId = selectedPlaceId
        }
    }
    
    //tableView row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    //ALERT
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    //tableView row editing delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let query = PFQuery(className: "Places")
            query.whereKey("objectId", equalTo: placeIdArray[indexPath.row])
            query.findObjectsInBackground { (objects, error) in
                if error != nil {
                    
                }else{
                    if objects != nil{
                        if objects!.count > 0{
                            let choosenPlaceObject = objects![0]
                            choosenPlaceObject.deleteInBackground { (success, error)in
                                if error != nil {
                                    print("Error")
                                }else{
                                    self.placeNameArray.remove(at: indexPath.row)
                                    self.placeIdArray.remove(at: indexPath.row)
                                    self.tableView.reloadData()
                                    self.makeAlert(titleInput: "Success", messageInput: "Deletion successful!")
                                }
                            }
                        }
                    }
                }
            }
                
        }
    }

}
