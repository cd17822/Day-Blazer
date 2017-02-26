//
//  TableViewCell.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/25/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    
    @IBOutlet var iconbg: UIView! {
        didSet {
            iconbg.layer.cornerRadius = 27
        }
    }
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
