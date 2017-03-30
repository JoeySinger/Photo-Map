//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate, LocationsViewControllerDelegate {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var SFMapView: MKMapView!
    var pickedImage: UIImage!

    @IBAction func onCameraPress(_ sender: UIButton) {
        let iPickerController = UIImagePickerController()
        iPickerController.delegate = self
        iPickerController.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            iPickerController.sourceType = .camera
        } else{
            iPickerController.sourceType = .photoLibrary
        }
        present(iPickerController, animated: true) {
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickedImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.dismiss(animated: true) { 
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        let annotation = MKPointAnnotation()
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: longitude)
        SFMapView.addAnnotation(annotation)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }

        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = pickedImage
        
        return annotationView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        SFMapView.delegate = self
        setupUI()
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)

        SFMapView.setRegion(region, animated: false)
    }
    
    func setupUI(){
        cameraButton.layer.cornerRadius = cameraButton.bounds.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }


}
