//
//  NearByCell.swift
//  faceapp
//
//  Created by ankur kumawat on 3/9/17.
//  Copyright © 2017 sixthsense. All rights reserved.
//

import UIKit

class NearByCell: UITableViewCell {
    @IBOutlet weak var image_view: UIImageView!

    @IBOutlet weak var name_lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
