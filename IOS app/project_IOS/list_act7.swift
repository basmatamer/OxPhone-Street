//
//  list_act7.swift
//  project_design
//
//  Created by Mohamed A Tawfik on Jul/11/18.
//  Copyright © 2018 Aya_Basma_Habiba. All rights reserved.
//

import UIKit

class list_act7: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var orders: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
