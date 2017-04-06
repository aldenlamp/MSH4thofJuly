//
//  Sponsors.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

import Firebase
import FirebaseStorage

var viewLoaded = false

extension Notification.Name {
    static let reload = Notification.Name("reload")
}

class Sponsors: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var becomeASponsorButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var currentLoadingStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLoaded = true
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        
        becomeASponsorButton.layer.backgroundColor = UIColor.clear.cgColor
        becomeASponsorButton.backgroundColor = UIColor.clear
        becomeASponsorButton.layer.borderColor = UIColor.black.cgColor
        becomeASponsorButton.layer.borderWidth = 4
        becomeASponsorButton.layer.masksToBounds = true
        becomeASponsorButton.layer.cornerRadius = 8
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
    
    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasLoaded{
            return sponsors[section].count
        }else{
            if section == 0 { return 1 } else { return 0 }
        }
    }
    
    func titleForHeader(section: Int) -> String {
        switch section {
        case 0: return "Platinum"
        case 1: return "Gold"
        case 2: return "Silver"
        case 3 : return "Bronze"
        default: return "Fail"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: self.view.frame.width, height: 35))
        label.text = titleForHeader(section: section)
        label.font = UIFont(name: "Avenir-Heavy", size: 20)
        view.backgroundColor = UIColor(red:  1, green: 1, blue: 1, alpha: 0.7)
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 5))
        topView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
        let bottomView = UIView(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 5))
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3)
        view.addSubview(bottomView)
        view.addSubview(topView)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < 3{
            return 130
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section < 3 && hasLoaded{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")! as! SponsorCell
            let cellTitle = sponsors[indexPath.section][indexPath.row]
            
            cell.backgroundColor = UIColor.clear
            cell.titleLabel.text = cellTitle
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            cell.sponsorImageView.image = sponsorInfo[cellTitle]?[1] as? UIImage
            if indexPath.section != 0{
                cell.titleLabel.font = UIFont(name: "Avenir-Medium", size: 30)
            }else{
                cell.titleLabel.font = UIFont(name: "Avenir-Heavy", size: 30)
            }
            
            return cell
        }else if indexPath.section == 3 && hasLoaded{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.font = UIFont(name: "Avenir-Medium", size: 27)
            cell.textLabel?.text = sponsors[3][indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.backgroundColor = UIColor.white
            cell?.textLabel?.text = "Loading Please Wait"
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.adjustsFontSizeToFitWidth = true
            cell?.textLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellTitle = sponsors[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "showWebview", sender: sponsorInfo[cellTitle]![0] as! String)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SponsorWebView{
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            destination.websiteString = sender as! String
        }
    }
    
    @IBAction func becomeASponsor(_ sender: Any) {
        performSegue(withIdentifier: "showWebview", sender: "http://www.mshjuly4th.com/sponsors.html")
    }
}



class SponsorCell: UITableViewCell {
    @IBOutlet var sponsorImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
}
