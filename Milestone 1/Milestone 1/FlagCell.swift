//
//  FlagCellTableViewCell.swift
//  Milestone 1
//
//  Created by Samuel Shi on 3/5/21.
//

import UIKit

class FlagCell: UITableViewCell {
  @IBOutlet var flagImage: UIImageView!
  @IBOutlet var flagTitle: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
