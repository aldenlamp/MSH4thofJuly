//
//  ViewController.swift
//  Sending Data to Firebase
//
//  Created by alden lamp on 3/15/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet var iamgeVidew: UIImageView!
    
    @IBOutlet var name: UITextField!
    
    @IBOutlet var website: UITextField!
    
    @IBOutlet var level: UISegmentedControl!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("sponsors").child("gold").child("NewTest").child("label").setValue("A great label")
        ref.child("sponsors").child("gold").child("NewTest").child("image").setValue("test Sponsor")
        ref.child("sponsors").child("gold").child("NewTest").child("link").setValue("https://test.mshjuly4th.com")
        print("\n\nviewloaded\n\n")
        
    }
    
    
    func dismissKey(){
        self.view.endEditing(true)
    }
    
    @IBAction func addSponsor(_ sender: Any) {
        
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tapGesture)
        
        let ref = FIRDatabase.database().reference()
        
        var levelString = ""
        switch(level.selectedSegmentIndex){
        case 0: levelString = "Platnum"
        case 1: levelString = "Gold"
        case 2: levelString = "Silver"
        case 3: levelString = "Bronze"
        default: break
        }
        
        ref.child("Sponcers").child("\(name.text!)").child("Level").setValue(levelString)
        
        let imageData : String = (UIImagePNGRepresentation(iamgeVidew.image!)?.base64EncodedString())!
        
//        ref.child("Sponcers").child("\(name.text!)").child("Image").setValue(imageData)
        
        let webpage = website.text?.replacingOccurrences(of: ".", with: "__PERIOD__")
        
        ref.child("Sponcers").child("\(name.text!)").child("Website").setValue(webpage)
    }

    @IBAction func addImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        present(image, animated: true, completion: nil)
        print("started to added")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("CANCILED")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("ADDED")
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        iamgeVidew.contentMode = .scaleAspectFit
        iamgeVidew.image = chosenImage
        dismiss(animated:true, completion: nil)
        iamgeVidew.layer.borderColor = UIColor.clear.cgColor
    }
    
    
    

}

