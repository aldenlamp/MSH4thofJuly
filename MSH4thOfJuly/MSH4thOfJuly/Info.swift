//
//  FirstViewController.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

var hasLoaded = false
var sponsors : [[String]] = [[String]]()
var sponsorInfo : [String : [Any]] = [String : [Any]]()

class Info: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSponsorInfo(completion: {
            hasLoaded = true
            NotificationCenter.default.post(name: .reload, object: nil)
        })
        
    }
    
    var count = 0
    
    func getSponsorInfo(completion : @escaping () -> Void){
        
        for _ in 0...3 { sponsors.append([String]()) }
        let ref = FIRDatabase.database().reference()
        
        ref.observe(.value, with: {
            snapshot in
            
            var snapshotValues = (snapshot.value! as! [String: [String : Any]])["Sponsors"]! as! [String : [String : String]]
            print(snapshotValues)
            print(snapshotValues.count)
            self.count = snapshotValues.count
            for (key, val) in snapshotValues{
                switch (val["Level"]!){
                case "Platinum" : sponsors[0].append(key)
                case "Gold" : sponsors[1].append(key)
                case "Silver" : sponsors[2].append(key)
                case "Bronze" : sponsors[3].append(key)
                default : break
                }
                sponsorInfo[key] = [Any]()
                let website = val["Website"]?.replacingOccurrences(of: "__PERIOD__", with: ".")
                sponsorInfo[key]?.append(website!)
            }
            
            self.getImages(data: snapshotValues, completion: { completion() })
            
        })
    }
    
    func getImages(data: [String: [String : String]], completion : @escaping () -> ()){
        let storage = FIRStorage.storage()
        var counter = 0
        for (key, val) in data{
            if val["Level"] != "Bronze"{
                let pathString = "sponsors/\(val["Image"]!.replacingOccurrences(of: "__PERIOD__", with: ".")).png"
                sponsorInfo[key]?.append(UIImage.self)
                let pathReference = storage.reference(withPath: pathString)
                pathReference.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                    counter += 1
                    if error != nil{
                        print("Tehere was an error")
                    }else{
                        sponsorInfo[key]?[1] = (UIImage(data: data!)!)
                        if self.count == counter + 1{
                            completion()
                        }
                    }
                }
            }
        }
    }
}

extension UIViewController{
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
