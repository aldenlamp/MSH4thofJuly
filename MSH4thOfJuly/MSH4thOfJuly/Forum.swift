//
//  Forum.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/15/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class Forum: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
