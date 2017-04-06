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
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell") as! FAQCell
        cell.questionLabel.text = "This is an example question that I'm going to ask about the 4th of july event: Is it LITTTT? (Pun intended)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func didMoveToSuperview() {
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.numberOfLines = 0
        
    }
    
    
    func openView(){
        self.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>)
    }
    
}
