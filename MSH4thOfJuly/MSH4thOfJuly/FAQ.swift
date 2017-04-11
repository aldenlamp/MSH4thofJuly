//
//  FAQ.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/15/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class FAQ: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var selectedIndex = -1
    
    @IBOutlet var addYourOwnButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.sectionHeaderHeight = 4
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        
        addYourOwnButton.layer.cornerRadius = 8
        addYourOwnButton.layer.masksToBounds = true
        addYourOwnButton.layer.borderColor = UIColor.black.cgColor
        addYourOwnButton.layer.borderWidth = 4
        addYourOwnButton.addTarget(self, action: #selector(backToForum), for: .touchUpInside)
    }
    
    func backToForum() {
        transitionToView = true
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex{
            return self.calculateHeight(indexPath: indexPath)
        }else{
            return firstViewHeight(indexPath: indexPath).size.height
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        
        cell.backgroundColor = UIColor.clear
        
        cell.constraint.constant = firstViewHeight(indexPath: indexPath).height
        cell.firstView.frame.size = firstViewHeight(indexPath: indexPath).size
        cell.firstView.backgroundColor = UIColor.clear
        
        cell.answerView.backgroundColor = UIColor.clear
        
        cell.questionLabel.frame = firstViewHeight(indexPath: indexPath)
        cell.questionLabel.text = FAQKeys[indexPath.row]
        
        cell.answerLabel.frame = caluclateSummaryLabelFrame(cell: cell, indexPath: indexPath)
        cell.answerLabel.text = FAQValues[indexPath.row]
        
        if indexPath.row != 0{
            cell.separator.frame = CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 4)
            cell.separator.layer.masksToBounds = true
            cell.separator.layer.cornerRadius = 4
            cell.separator.backgroundColor = UIColor.black
            cell.addSubview(cell.separator)
        }
            
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndex == indexPath.row{
            selectedIndex = -1
        }else{
            selectedIndex = indexPath.row
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat{
        let cell = self.tableView.cellForRow(at: indexPath) as! FAQCell
        cell.answerLabel.frame = self.caluclateSummaryLabelFrame(cell: cell, indexPath: indexPath)
        return (cell.firstView.frame.size.height) + (cell.answerLabel.frame.size.height)
    }
    
    func caluclateSummaryLabelFrame(cell: FAQCell, indexPath: IndexPath) -> CGRect{
        cell.answerLabel.text = FAQValues[indexPath.row]
        cell.answerLabel.numberOfLines = 0
        var frame = cell.answerLabel.frame
        let maxSize = CGSize(width: cell.answerLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.answerLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 16
        return frame
    }
    
    func firstViewHeight(indexPath: IndexPath) -> CGRect{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        cell.questionLabel.text = FAQKeys[indexPath.row]
        cell.questionLabel.numberOfLines = 0
        var frame = cell.questionLabel.frame
        let maxSize = CGSize(width: cell.questionLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.questionLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 21
        return frame
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}


class FAQCell: UITableViewCell{
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var answerView: UIView!
    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var constraint: NSLayoutConstraint!
    
    let separator = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 4))
    
}
