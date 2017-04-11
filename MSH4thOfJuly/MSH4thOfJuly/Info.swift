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

var FAQKeys = [String]()
var FAQValues = [String]()

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
            
            var FAQInfo = (snapshot.value! as! [String: [String : Any]])["FAQ"]! as! [String : [String : String]]
            
            for (_, val) in FAQInfo{
                FAQKeys.append(val["q"])
                FAQValues.append(val["a"])
            }
            
            var snapshotValues = (snapshot.value! as! [String: [String : Any]])["sponsors"]! as! [String : [String : [String : String]]]
            
//            self.count = snapshotValues.count
            
            for (key, val) in snapshotValues{
                
                var index = -1
                
                switch key{
                case "bronze" : index = 3
                case "silver" : index = 2
                case "gold" : index = 1
                case "platinum" : index = 0
                default : index = -1
                }
                
                for (sponsor, value) in val{
                    sponsors[index].append(sponsor)
                    sponsorInfo[sponsor] = [Any]()
                    let website = value["link"]
                    sponsorInfo[sponsor]?.append(website!)
                    self.count += 1
                }
                
                
                /*
                
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
                */
            }
            
            self.getImages(data: snapshotValues, completion: { completion() })
            
        })
    }
    
    func getImages(data: [String: [String : [String : String]]], completion : @escaping () -> ()){
        let storage = FIRStorage.storage()
        var counter = 0
        
        for (type, stuff) in data{
            if type != "bronze"{
                
                
                for (key, val) in stuff{
                    counter += 1
                    sponsorInfo[key]?.append(UIImage())
                    let pathRefrence = storage.reference(withPath: "sponsors/\(val["image"]!)")
                    pathRefrence.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                        counter += 1
                        if error != nil{
                            print("Error: \(error)")
                        }else{
                            sponsorInfo[key]?[1] = (UIImage(data: data!)!)
                            if self.count == counter{
                                print(sponsorInfo)
                                completion()
                            }
                        }
                    }
                }
            }else{
                for (key, _) in stuff{
                    sponsorInfo[key]?.append(UIImage())
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
