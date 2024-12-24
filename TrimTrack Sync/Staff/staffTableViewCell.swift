//
//  staffTableViewCell.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 20/12/2024.
//

import UIKit

class staffTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ContactLbl: UILabel!
    @IBOutlet weak var joiningdateLbl: UILabel!
    @IBOutlet weak var designbl: UILabel!
    @IBOutlet weak var otherlb: UILabel!
    @IBOutlet weak var addresslb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
