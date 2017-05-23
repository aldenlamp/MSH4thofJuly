
//  SecondViewController.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import Firebase

class Contact: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var sizesForAll = [Int : CGRect]()
    var somethingTest = [Int : Bool]()
    
    var selectedIndex = -1
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var emailUsButton: UIButton!
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailImage: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if emailView.frame.contains(touches.first!.location(in: self.view)){
            emailUs()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        emailView.layer.borderColor = UIColor.black.cgColor
        emailView.layer.borderWidth = 4
        emailView.layer.masksToBounds = true
        emailView.layer.cornerRadius = 8
        emailView.backgroundColor = UIColor.clear
        
        emailUsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        emailUsButton.contentHorizontalAlignment = .left
        emailUsButton.addTarget(self, action: #selector(emailUs), for: .touchUpInside)
        
        emailImage.image = UIImage(named: "message_filled")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.sectionHeaderHeight = 4
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData(_:)), name: .reload, object: nil)
        
    }
    
    func reloadTableData(_ notification: Notification) {
        tableView.reloadData()
    }

    
    
    //MARK: - TableView
    
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
            if let a = somethingTest[indexPath.row]{
                return a ? (sizesForAll[indexPath.row]?.size.height)! : firstViewHeight(indexPath: indexPath).size.height
            }else{
                return firstViewHeight(indexPath: indexPath).size.height
            }
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
        
        cell.firstView.backgroundColor = UIColor.clear
        cell.answerView.backgroundColor = UIColor.clear
        
        if let a = somethingTest[indexPath.row]{
            cell.questionLabel.frame = a ? sizesForAll[indexPath.row]! : firstViewHeight(indexPath: indexPath)
            cell.constraint.constant = a ? sizesForAll[indexPath.row]!.height : firstViewHeight(indexPath: indexPath).height
            cell.firstView.frame.size = a ? sizesForAll[indexPath.row]!.size : firstViewHeight(indexPath: indexPath).size
        }else{
            cell.questionLabel.frame = firstViewHeight(indexPath: indexPath)
            cell.constraint.constant = firstViewHeight(indexPath: indexPath).height
            cell.firstView.frame.size = firstViewHeight(indexPath: indexPath).size
        }
        
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
        
        if(indexPath.row == 3 || indexPath.row == 4){
            print("\(indexPath.row): \t\(cell.frame.size.height)\t ")
        }
        return cell
        
    }
    
    var tester = [CGFloat]()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tester.append(self.tableView(tableView, heightForRowAt: indexPath))
        print(self.tableView(tableView, heightForRowAt: indexPath))
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
        if(indexPath.row != selectedIndex){frame.size.height = 0;}
        return frame
    }
    
    func firstViewHeight(indexPath: IndexPath) -> CGRect{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        cell.questionLabel.text = FAQKeys[indexPath.row]
        cell.questionLabel.numberOfLines = 0
        var frame = cell.questionLabel.frame
        let maxSize = CGSize(width: self.view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.questionLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 21
        sizesForAll[indexPath.row] = frame
        somethingTest[indexPath.row] = false
        return frame
    }

    //MARK: - Email
    
    func emailUs() {
        if MFMailComposeViewController.canSendMail(){
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["info@mshjuly4th.com"])
            mail.setSubject("A Question")
            mail.setMessageBody("Your message goes here!", isHTML: false)
            present(mail, animated: true, completion: { print("has been shown") })
        }else{
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
