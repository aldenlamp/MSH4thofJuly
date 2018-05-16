//
//  FirstViewController.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import MapKit

import UIKit
import Firebase
import FirebaseStorage

var usingPersistantMemory = false

var hasLoaded = false
var sponsors : [[String]] = [[String]]()
var sponsorInfo : [String : [Any]] = [String : [Any]]()
var eventInfo = [String : Any]()

var FAQKeys = [String]()
var FAQValues = [String]()

class Info: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var timeLocationLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var donateButton: UIButton!
    
    @IBOutlet var scheduleButton: UIButton!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.mapView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        titleLabel.adjustsFontSizeToFitWidth = true
        timeLocationLabel.adjustsFontSizeToFitWidth = true
        
        mapView.layer.cornerRadius = 16
        mapView.layer.masksToBounds = true
        
        donateButton.layer.cornerRadius = 8
        donateButton.layer.masksToBounds = true
        donateButton.layer.borderColor = UIColor.black.cgColor
        donateButton.layer.borderWidth = 4
        
        donateButton.titleLabel?.adjustsFontSizeToFitWidth = true
        donateButton.titleLabel?.textColor = UIColor.black
        donateButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 27)
        donateButton.tintColor = UIColor.black
        
        donateButton.addTarget(self, action: #selector(seg), for: .touchUpInside)
        
        scheduleButton.layer.cornerRadius = 8
        scheduleButton.layer.masksToBounds = true
        scheduleButton.layer.borderColor = UIColor.black.cgColor
        scheduleButton.layer.borderWidth = 4
        
        scheduleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        scheduleButton.setTitle("Schedule", for: .normal)
        scheduleButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 27)
        scheduleButton.tintColor = UIColor.black
        
        scheduleButton.addTarget(self, action: #selector(seg2), for: .touchUpInside)
        
        loadData()
        setUpMap()
    }
    
    func saveData(){
        let ud = UserDefaults.standard
        ud.set(true, forKey: "hasBeenSaved")
        ud.set(FAQValues, forKey: "FAQValues")
        ud.set(FAQKeys, forKey: "FAQKeys")
        ud.set(sponsors, forKey: "sponsors")
        ud.set(sponsorInfo, forKey: "sponsorInfo")
        ud.set(eventInfo, forKey: "eventInfo")
    }
    
    func loadData(){
        let ud = UserDefaults.standard
        if let a = ud.value(forKey: "hasBeenSaved"){
            
            if a as! Bool == true{
                FAQValues = ud.value(forKey: "FAQValues") as! [String]
                FAQKeys = ud.value(forKey: "FAQKeys") as! [String]
                sponsorInfo = ud.value(forKey: "sponsorInfo") as! [String : [Any]]
                sponsors = ud.value(forKey: "sponsors") as! [[String]]
                eventInfo = ud.value(forKey: "eventInfo") as! [String : Any]
                loadEventInfo(data: eventInfo)
                hasLoaded = true
            }else{
                hasLoaded = false
            }
        }else{
            hasLoaded = false
            delay(0.1){
                let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
                connectedRef.observe(.value, with: { (connected) in
                    self.delay(2){
                        if let boolean = connected.value as? Bool, boolean == true{
                            
                        } else {
                            self.tabBarController?.tabBar.isHidden = true
                            self.performSegue(withIdentifier: "ShowWifi", sender: nil)
                        }
                    }
                })
            }
        }
        
        getSponsorInfo(completion: {
            print("COMPLETED")
            hasLoaded = true
            self.saveData()
            
        })

    }
    
    func setUpMap(){
        
        let location: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.720396, longitude: -74.315729), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(location, animated: true)
    }
    
    func addAnnotations(locations: [String : [String : Any]]){
        for (key, val) in locations{
            
            var annotation = MKPointAnnotation()
            annotation.title = key
            annotation.coordinate = CLLocationCoordinate2D(latitude: val["latitude"]! as! Double, longitude: val["longitude"]! as! Double)
            annotation.subtitle = val["subtitle"]! as! String
            mapView.addAnnotation(annotation)
        }
    }
    
    
    
    func seg2(){
        performSegue(withIdentifier: "showSchedule", sender: nil)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func seg(){
        UIApplication.shared.openURL(NSURL(string: "https://www.paypal.com/donate/?token=GkuIrWHQ-9QnttvazD557S0nQC1lGSa6Ynt107CESzhSEIeQ3d87b5zTKPN-yeRLio0Kc0")! as URL)
//        performSegue(withIdentifier: "showSched", sender: nil)
//        self.navigationController?.navigationBar.isHidden = false
//        self.tabBarController?.tabBar.isHidden = true
    }
    
    func loadEventInfo(data: [String : Any]){
        
        addAnnotations(locations: data["locations"] as! [String : [String: Any]])
        
        timeLocationLabel.text = (data["eventLocation"] as! String)
        descriptionLabel.text = data["description"] as? String
        
        descriptionLabel.frame = firstViewHeight(text: (data["eventLocation"] as! String), label: descriptionLabel)
        
        heightConstraint.constant = firstViewHeight(text: (data["description"] as! String), label: descriptionLabel).height
        
        times = [String]()
        descriptions = [String]()
        titles = [String]()
        
        for i in data["schedule"] as! [[String : String]]{
            times.append(i["time"]!)
            descriptions.append(i["description"]!)
            titles.append(i["title"]!)
        }
        
    }
    
    
    
    func firstViewHeight(text: String, label : UILabel) -> CGRect{
        label.text = text
        label.numberOfLines = 0
        
        var frame = label.frame
        let maxSize = CGSize(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        
        let requiredSize = label.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 17
        return frame
    }
    
    
    //MARK: - Loading data from FireBase
    
    var count = 0
    
    func getSponsorInfo(completion : @escaping () -> Void){
        
        let ref = FIRDatabase.database().reference()
        
        ref.observe(.value, with: {
            snapshot in
            
            let snapshotValues = (snapshot.value as! [String : Any])["sponsors"] as! [String : [String : [String : String]]]
            eventInfo = (snapshot.value! as! [String : Any])["eventInfo"] as! [String : Any]
            let FAQInfo = (snapshot.value! as! [String : Any])["FAQ"]! as! [[String : String]]
            
            self.loadEventInfo(data: eventInfo)
            
            
            FAQValues = [String]()
            FAQKeys = [String]()
            
            for val in FAQInfo{
                for (key, value) in val{
                    
                    if key == "a"{
                        FAQValues.append(value)
                    }else if key == "q"{
                        FAQKeys.append(value)
                    }
                }
                
            }
            
            sponsors = [[String]]()
            for _ in 0...3 { sponsors.append([String]()) }
            sponsorInfo = [String : [Any]]()
            
            for (key, val) in snapshotValues{
                
                var index = -1
                
                switch key{
                case "bronze" : index = 3
                case "silver" : index = 2
                case "gold" : index = 1
                case "platinum" : index = 0
                default : index = -1
                }
                
                for (_, value) in val{
                    sponsors[index].append(value["label"]!)
                    sponsorInfo[value["label"]!] = [String]()
                    if index == 3 || index == 2 {
                        sponsorInfo[value["label"]!]?.append("Nope")
                    }else{
                        let website = value["link"]
                        sponsorInfo[value["label"]!]?.append(website!)
                    }
                    self.count += 1
                }
                
            }
            
            self.getImages(data: snapshotValues, completion: { completion() })
            
        })
    }
    
    func getImages(data: [String: [String : [String : String]]], completion : @escaping () -> ()){
        let storage = FIRStorage.storage()
        var counter = 0
        
        for (type, stuff) in data{
            if type != "bronze"{
                
                
                for (_, val) in stuff{
                    counter += 1
                    sponsorInfo[val["label"]!]?.append("")
//                    print(val)
                    let pathRefrence = storage.reference(withPath: "sponsors/\(val["image"]!)")
                    pathRefrence.data(withMaxSize: 1 * 2048 * 2018) { data, error in
                        
                        if error != nil{
                            print("Error: \(String(describing: error))")
                        }else{
                            
                            
                            sponsorInfo[val["label"]!]?[1] = UIImagePNGRepresentation(UIImage(data: data!)!)
                            if self.count == counter{
                                completion()
                            }
                        }
                    }
                }
            }else{
                for (_, val) in stuff{
                    sponsorInfo[val["label"]!]?.append("")
                }
                counter += 1
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

