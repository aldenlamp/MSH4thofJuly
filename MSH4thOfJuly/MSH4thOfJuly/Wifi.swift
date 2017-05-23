//
//  Wifi.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 4/24/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class Wifi: UIViewController {

    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        label.adjustsFontSizeToFitWidth = true
        
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { (connected) in
            if let boolean = connected.value as? Bool, boolean == true{
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            } else {
                print("not connected")
            }
        })
        
    }

    
    
    
}
