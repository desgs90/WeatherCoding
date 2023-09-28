//
//  CollectionCell.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/27/23.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var backgroundIcon: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var midLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundIcon.image = nil
        bottomLabel.text = ""
        midLabel.text = ""
        topLabel.text = ""
    }
    
    override func prepareForReuse() {
        backgroundIcon.image = nil
        bottomLabel.text = ""
        midLabel.text = ""
        topLabel.text = ""
    }

}
