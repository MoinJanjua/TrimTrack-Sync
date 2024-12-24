//
//  ClintTableViewCell.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class ClintTableViewCell: UITableViewCell {

    @IBOutlet weak var namelb: UILabel!
    @IBOutlet weak var contactlb: UILabel!
    @IBOutlet weak var genderlb: UILabel!
    @IBOutlet weak var addreslb: UILabel!
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var bgview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgview.layer.cornerRadius = 18
        bgview.layer.shadowColor = UIColor.black.cgColor
        bgview.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgview.layer.shadowOpacity = 0.3
        bgview.layer.shadowRadius = 4.0
        bgview.layer.masksToBounds = false
        bgview.alpha = 1.5 // Adjust opacity as needed
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
