//
//  CustomeTableViewCell.swift
//  ProducerApp
//
//  Created by Cybermac002 on 04/05/18.
//  Copyright © 2018 Cybermac002. All rights reserved.
//

import UIKit

class CustomeTableViewCell: UITableViewCell {

    ////////// Home View Cell Outlate
    @IBOutlet weak var timeview: UIView!
    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var subtitlelablel: UILabel!
    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var eventcountrynamelabel: UILabel!
    @IBOutlet weak var eventtimelabel: UILabel!
    @IBOutlet weak var locationimageview: UIImageView!
    @IBOutlet weak var eventdatelablel: UILabel!
    
    ////////// Create Event Cell
    @IBOutlet weak var eventtitlelabel: UILabel!
    @IBOutlet weak var eventsubtitlelabel: UILabel!
    @IBOutlet weak var createeventimageview: UIImageView!
    @IBOutlet weak var publicprivateswitchbutton: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
