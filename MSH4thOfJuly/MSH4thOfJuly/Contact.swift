
//  SecondViewController.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class Contact: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var bottomImage: UIImageView!
    
    @IBOutlet var forumsButton: UIButton!
    @IBOutlet var FAQButton: UIButton!
    @IBOutlet var emailUsButton: UIButton!
    
    @IBOutlet var forumView: UIView!
    @IBOutlet var FAQView: UIView!
    @IBOutlet var emailView: UIView!
    
    @IBOutlet var forumImage: UIImageView!
    @IBOutlet var FAQImage: UIImageView!
    @IBOutlet var emailImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        forumView.layer.borderColor = UIColor.black.cgColor
        forumView.layer.borderWidth = 4
        forumView.layer.masksToBounds = true
        forumView.layer.cornerRadius = 8
        forumView.backgroundColor = UIColor.clear
        
        forumsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        forumsButton.contentHorizontalAlignment = .left
        
        forumImage.image = UIImage(named: "activity_feed_filled")
        
        FAQView.layer.borderColor = UIColor.black.cgColor
        FAQView.layer.borderWidth = 4
        FAQView.layer.masksToBounds = true
        FAQView.layer.cornerRadius = 8
        FAQView.backgroundColor = UIColor.clear
        
        FAQButton.titleLabel?.adjustsFontSizeToFitWidth = true
        FAQButton.contentHorizontalAlignment = .left
        
        FAQImage.image = UIImage(named: "faq_filled")
        
        emailView.layer.borderColor = UIColor.black.cgColor
        emailView.layer.borderWidth = 4
        emailView.layer.masksToBounds = true
        emailView.layer.cornerRadius = 8
        emailView.backgroundColor = UIColor.clear
        
        emailUsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        emailUsButton.contentHorizontalAlignment = .left
        
        emailImage.image = UIImage(named: "message_filled")
        
        if UIDevice.current.showImage{
            bottomImage.isHidden = false
            forumView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        }else{
            bottomImage.isHidden = true
            forumView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50).isActive = true
            print("test")
        }
        bottomImage.alpha = 0.7
    }
    
    @IBAction func forums(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: "Show Forum", sender: nil)
    }
    
    
    
    @IBAction func FAQ(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        performSegue(withIdentifier: "Show FAQ", sender: nil)
    }
    
    //MARK: - Email
    
    @IBAction func emailUs(_ sender: Any) {
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

public extension UIDevice {
    
    var showImage: Bool {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return false        //"iPhone 4"
        case "iPhone4,1":                           return false        //"iPhone 4s"
        case "iPhone5,1", "iPhone5,2":              return false        //"iPhone 5"
        case "iPhone5,3", "iPhone5,4":              return false        //"iPhone 5c"
        case "iPhone6,1", "iPhone6,2":              return false        //"iPhone 5s"
        case "iPhone7,2":                           return true         //"iPhone 6"
        case "iPhone7,1":                           return true         //"iPhone 6 Plus"
        case "iPhone8,1":                           return true         //"iPhone 6s"
        case "iPhone8,2":                           return true         //"iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":              return true         //"iPhone 7"
        case "iPhone9,2", "iPhone9,4":              return true         //"iPhone 7 Plus"
        case "iPhone8,4":                           return false        //"iPhone SE"
        case "i386", "x86_64":                      return true         //Simulator
        default:                                    return false
        }
    }
    
}
