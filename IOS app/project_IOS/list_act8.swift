//
//  list_act8.swift
//  project_design
//
//  Created by Mohamed A Tawfik on Jul/11/18.
//  Copyright © 2018 Aya_Basma_Habiba. All rights reserved.
//

import UIKit

class list_act8: UITableViewCell {

    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var item_name: UILabel!
    @IBOutlet weak var order_date: UILabel!
    @IBOutlet weak var shop_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
