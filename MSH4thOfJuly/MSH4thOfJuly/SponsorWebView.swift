//  SponsorWebView.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/19/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class SponsorWebView: UIViewController, UIWebViewDelegate{

    var websiteString = String()
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(websiteString)
        
        activityIndicator.layer.zPosition = 1
        activityIndicator.sizeToFit()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.black
        let url = NSURL (string: websiteString);
        let request = NSURLRequest(url: url! as URL);
        webView.loadRequest(request as URLRequest);
        webView.delegate = self
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                self.navigationController?.navigationBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
    }

}
