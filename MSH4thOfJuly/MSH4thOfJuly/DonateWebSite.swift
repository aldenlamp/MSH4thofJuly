//
//  DonateWebSite.swift
//  MSH4thOfJuly
//
//  Created by alden lamp on 3/11/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class DonateWebSite: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.layer.zPosition = 1
        
        activityIndicator.sizeToFit()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        let url = NSURL (string: "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=23TANJM9SJPGJ");
        let request = NSURLRequest(url: url! as URL);
        webView.loadRequest(request as URLRequest);
        webView.delegate = self
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
}
