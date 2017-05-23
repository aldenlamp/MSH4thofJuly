//
//  Schedule.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 4/14/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

var times = [String]()
var titles = [String]()
var descriptions = [String]()

class Schedule: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let secondView = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 4))
        secondView.backgroundColor = UIColor.black
        secondView.layer.masksToBounds = true
        secondView.layer.cornerRadius = 4
        view.backgroundColor = UIColor.clear
        view.addSubview(secondView)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row{
            return heightOfCell(indexPath: indexPath)
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ScheduleCell
        
        
        cell.timeLabel.text = times[indexPath.row] + " :"
        cell.titleLabel.text = titles[indexPath.row]
        cell.titleLabel.adjustsFontSizeToFitWidth = true
        
        cell.descriptionLabel.frame = viewForCell(indexPath: indexPath)
        cell.descriptionLabel.text = descriptions[indexPath.row]
        
        cell.backgroundColor = UIColor.clear
        cell.descriptionView.backgroundColor = UIColor.clear
        cell.titleView.backgroundColor = UIColor.clear
        
        cell.heightContraint.constant = viewForCell(indexPath: indexPath).height
        
        print(indexPath.row)
        
        if indexPath.row != 0{
            print(indexPath.row)
            
            cell.timeToTop.constant = 12
            cell.descriptionToTop.constant = 12
            
            let secondView = UIView(frame: CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 4))
            secondView.backgroundColor = UIColor.black
            secondView.layer.masksToBounds = true
            secondView.layer.cornerRadius = 4
            cell.addSubview(secondView)
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == selectedIndex{
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func heightOfCell(indexPath: IndexPath) -> CGFloat{
        let frameHeight = viewForCell(indexPath: indexPath).height
        return frameHeight + 60
    }
    
    func viewForCell(indexPath: IndexPath) -> CGRect{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ScheduleCell
        
        cell.descriptionLabel.text = descriptions[indexPath.row]
        cell.descriptionLabel.numberOfLines = 0
        
        var frame = cell.descriptionLabel.frame
        let maxFrame = CGSize(width: cell.descriptionLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        
        let reqSize = cell.descriptionLabel.sizeThatFits(maxFrame)
        frame.size.height = reqSize.height + 40
        return frame
        
    }

}


class ScheduleCell: UITableViewCell{
    
    @IBOutlet var titleView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var heightContraint: NSLayoutConstraint!
    
    @IBOutlet var timeToTop: NSLayoutConstraint!
    @IBOutlet var descriptionToTop: NSLayoutConstraint!
    
}
