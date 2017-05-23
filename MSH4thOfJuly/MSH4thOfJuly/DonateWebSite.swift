//
//  DonateWebSite.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class DonateWebSite: UIViewController {

    
    @IBOutlet var titleLaebl: UILabel!
    
    @IBOutlet var donateButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLaebl.adjustsFontSizeToFitWidth = true
        
        donateButton.layer.cornerRadius = 8
        donateButton.layer.masksToBounds = true
        donateButton.layer.borderColor = UIColor.black.cgColor
        donateButton.layer.borderWidth = 4
        
        donateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        donateButton.titleLabel?.textColor = UIColor.black
        donateButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 27)
        donateButton.tintColor = UIColor.black
        
        donate("")
    }
    
    
    @IBAction func donate(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "http://donate.mshjuly4th.com/")! as URL)
        
    }
    
}
