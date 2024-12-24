//
//  expenseTableViewCell.swift
//  TrimTrack Sync
//
//  Created by Unique Consulting Firm on 21/12/2024.
//

import UIKit

class expenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var amounlb: UILabel!
    @IBOutlet weak var otherlb: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
