//
//  salesTableViewCell.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class salesTableViewCell: UITableViewCell {

    @IBOutlet weak var staffName: UILabel!
    @IBOutlet weak var clintName: UILabel!
    @IBOutlet weak var dressingType: UILabel!
    @IBOutlet weak var servicestype: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amiunt: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
