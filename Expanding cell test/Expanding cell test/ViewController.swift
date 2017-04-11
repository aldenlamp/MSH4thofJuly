//
//  ViewController.swift
//  Expanding cell test
//
//  Created by alden lamp on 4/6/17.
//  Copyright © 2017 alden lamp. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var selectedInedx = -1
    
    
    
    var keys = ["Fist Item", "This second item is going to be so long that it has to go on multiple lines bceause I want it to or else I am going to be very mad jk lol", "This is the third Item", "This is more lines of things that I am going to write baout", "Less things", "Less things but hopefully 2 lines or less"]
    
    var values = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                  "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",                   "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                  "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedInedx{
            return self.calculateHeight(indexPath: indexPath)
        }else{
            return firstViewHeight(indexPath: indexPath).size.height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        cell.firstLabel.text = keys[indexPath.row]
        cell.firstLabel.frame = firstViewHeight(indexPath: indexPath)
        cell.firstVie.frame.size = CGSize(width: firstViewHeight(indexPath: indexPath).width, height: firstViewHeight(indexPath: indexPath).height)// + 16)
        cell.constraint.constant = firstViewHeight(indexPath: indexPath).height
        cell.summaryLabel.frame = caluclateSummaryLabelFrame(cell: cell, indexPath: indexPath)
        cell.summaryLabel.text = values[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedInedx == indexPath.row{
        selectedInedx = -1
        }else{
            selectedInedx = indexPath.row
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat{
        let cell = self.tableView.cellForRow(at: indexPath) as! customCell
        cell.summaryLabel.frame = self.caluclateSummaryLabelFrame(cell: cell, indexPath: indexPath)
        return (cell.firstVie.frame.size.height) + (cell.summaryLabel.frame.size.height)
    }
    
    func caluclateSummaryLabelFrame(cell: customCell, indexPath: IndexPath) -> CGRect{
        cell.summaryLabel.text = values[indexPath.row]
        cell.summaryLabel.numberOfLines = 0
        var frame = cell.summaryLabel.frame
        let maxSize = CGSize(width: cell.summaryLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.summaryLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height
        return frame
    }
    
    func firstViewHeight(indexPath: IndexPath) -> CGRect{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        cell.firstLabel.text = keys[indexPath.row]
        cell.firstLabel.numberOfLines = 0
        var frame = cell.firstLabel.frame
        let maxSize = CGSize(width: cell.firstLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = cell.firstLabel.sizeThatFits(maxSize)
        frame.size.height = requiredSize.height + 17
        return frame
    }
    
    
    
    /*
     
     func calculateHeight(selectedIndexPath: IndexPath) -> CGFloat {
     let cell = self.expandTableView.cellForRow(at: selectedIndexPath) as! customCell
     cell.summaryLabel.frame = self.cellSummaryLabelFrame(cell: cell, selectedIndexPath: selectedIndexPath)
     return calculateMatchHeight(indexPath: selectedIndexPath) + 10 + cell.summaryLabel.frame.size.height + 10
     }
     
     func cellSummaryLabelFrame(cell: customCell, selectedIndexPath: IndexPath) -> CGRect {
     cell.summaryLabel.text = summaryArray[selectedIndexPath.row]
     cell.summaryLabel.numberOfLines = 0
     var labelFrame = cell.summaryLabel.frame
     let maxSize = CGSize.init(width: cell.summaryLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
     let requiredSize = cell.summaryLabel.sizeThatFits(maxSize)
     labelFrame.size.height = requiredSize.height
     return labelFrame
}
 */
}



class customCell: UITableViewCell {
    @IBOutlet var firstVie: UIView!
    @IBOutlet var constraint: NSLayoutConstraint!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondView: UIView!
    @IBOutlet var summaryLabel: UILabel!
}
