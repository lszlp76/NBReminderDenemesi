//
//  PlantCell.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit

class PlantCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var PostCountLabel: UILabel!
    @IBOutlet weak var PlantCreatedDate: UILabel!
    @IBOutlet weak var PlantDiaryName: UILabel!
    @IBOutlet weak var PlantAvatarImage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
