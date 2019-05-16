//
//  CountryCell.swift
//  Country Info
//
//  Created by Stefan Blos on 16.05.19.
//  Copyright © 2019 Stefan Blos. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet var flagImageView: FlagImageView!
    @IBOutlet var countryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
