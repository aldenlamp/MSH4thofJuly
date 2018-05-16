
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
    
    var selectedIndicies = Array<Int>()
    
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
        
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if  selectedIndicies.contains(indexPath.row){
            return calculateHeight(indexPath: indexPath)
        }else{
                return firstViewHeight(indexPath: indexPath)
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
        cell.constraint.constant = firstViewHeight(indexPath: indexPath)
        
        cell.questionLabel.text = FAQKeys[indexPath.row]
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
        if selectedIndicies.contains(indexPath.row){
            selectedIndicies.remove(at:selectedIndicies.index(of: indexPath.row)!)
        }else{
            selectedIndicies.append(indexPath.row)
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        let answerHeight = self.caluclateSummaryLabelFrame(cell: cell, indexPath: indexPath)
        let questionHeight = self.firstViewHeight(indexPath: indexPath)
        return questionHeight + answerHeight
    }
    
    func caluclateSummaryLabelFrame(cell: FAQCell, indexPath: IndexPath) -> CGFloat{
        cell.answerLabel.text = FAQValues[indexPath.row]
        cell.answerLabel.numberOfLines = 0
        var frame = cell.answerLabel.frame
        let maxSize = CGSize(width: cell.answerLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.answerLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 24
        if( selectedIndicies.contains(indexPath.row)){
            return frame.height
        }
        else {
            return 0.0
        }
        
    }
    
    func firstViewHeight(indexPath: IndexPath) -> CGFloat{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        cell.questionLabel.text = FAQKeys[indexPath.row]
        cell.questionLabel.numberOfLines = 0
        var frame = cell.questionLabel.frame
        frame.size.width = self.view.frame.width - 15
        let maxSize = CGSize(width: self.view.frame.width - 15, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.questionLabel.sizeThatFits(maxSize)
        cell.constraint.constant = requiredSize.height
        frame.size.height = requiredSize.height + 24
        return frame.height
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
 
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var constraint: NSLayoutConstraint!
    
    let separator = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 4))
    
}
